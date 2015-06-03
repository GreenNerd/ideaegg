require 'rails_helper'

RSpec.describe IdeaeggApi::FeaturesController, :type => :controller do
  include ApiSpecHelpers
  render_views

  let!(:user) { create :user }

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
    request.env["PRIVATE-TOKEN"] = user.private_token
  end

  describe 'GET ideas' do
    let!(:idea) { create :idea }
    let!(:another_idea) { create :idea }

    before :each do
      request.env["PRIVATE-TOKEN"] = user.private_token
      user.likes idea
    end

    it 'assigns the ideas' do
      get :ideas
      expect(assigns(:ideas)).to eq [idea, another_idea]
    end

    it 'returns a ideas json' do
      get :ideas, { per_page: 1, page: 2 }
      expect(json_response.first['id']).to eq another_idea.id
    end

    it 'response link header includes pagination info' do
      get :ideas, { per_page: 1, page: 1 }
      expect(response.header['Link']).not_to be_nil
    end
  end
end
