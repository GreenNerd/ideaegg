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

  describe 'GET index' do
    let!(:tag) { create :tag }
    let!(:another_tag) { create :tag, taggings_count: 0 }

    it 'assigns the tags' do
      get :index
      expect(assigns(:tags)).to eq [tag, another_tag]
    end

    it 'returns tags json' do
      get :index
      expect(json_response.size).to eq 2
    end
  end

  describe 'POST query' do
    let!(:tag) { create :tag, name: '中文名字' }
    let(:query_attr) { { name: '文' } }

    it 'returns results by a json' do
      post :query, query_attr
      expect(json_response.first['name']).to eq '中文名字'
    end
  end
end
