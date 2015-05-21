require 'rails_helper'

RSpec.describe IdeaeggApi::MarkdownController, :type => :controller do
  include ApiSpecHelpers
  render_views

  let!(:user) { create :user }
  let(:token_and_format) { { private_token: user.private_token, format: :json } }

  describe 'POST preview' do
    let(:content) { { content: '# test' } }

    it 'returns content html' do
      post :preview, content.merge(token_and_format)
      expect(json_response['content']).to eq "<h1>test</h1>\n"
    end
  end

end
