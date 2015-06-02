require 'rails_helper'

RSpec.describe IdeaeggApi::TagsController, :type => :controller do
  include ApiSpecHelpers
  render_views

  let!(:user) { create :user }

  before :each do
    request.env["PRIVATE-TOKEN"] = user.private_token
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe 'POST create' do
    let(:valid_attrs) { { name: 'test_name' } }
    let(:invalid_attrs) { { name: nil } }

    context 'when succeeding' do
      it 'create a new tag' do
        expect {
          post :create, valid_attrs
        }.to change { ::ActsAsTaggableOn::Tag.count }.by 1
      end

      it 'returns a tag json' do
        post :create, valid_attrs
        expect(json_response['name']).to eq 'test_name'
      end
    end

    context 'when failing' do
      it 'returns 422' do
        post :create, invalid_attrs
        expect(response.status).to eq 422
      end

      it 'returns a error json' do
        post :create, invalid_attrs
        expect(json_response['errors']).not_to be_nil
      end
    end
  end

end
