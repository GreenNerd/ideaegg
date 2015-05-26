require 'rails_helper'

RSpec.describe IdeaeggApi::IdeasController, :type => :controller do
  include ApiSpecHelpers
  render_views

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  let!(:user) { create :user }
  let(:token) { { private_token: user.private_token } }

  describe '#create' do
    let(:valid_attrs) { attributes_for :idea }
    let(:invalid_attrs) { attributes_for :idea, cover: nil }

    context 'succeeding' do
      it 'creates a idea with token in params' do
        expect {
          post :create, valid_attrs.merge(token)
        }.to change { Idea.count }.by 1
      end

      it 'creates a idea with token in header' do
        @request.env['PRIVATE-TOKEN'] = user.private_token
        expect {
          post :create, valid_attrs
        }.to change { Idea.count }.by 1
      end

      it 'returns a idea json' do
        post :create, valid_attrs.merge(token)
        expect(json_response['content_html']).to eq "<p><strong>World</strong></p>\n"
      end
    end

    context 'validation failing' do
      it 'returns 422 code' do
        post :create, invalid_attrs.merge(token)
        expect(response.status).to eq 422
      end

      it 'returns errors json' do
        post :create, invalid_attrs.merge(token)
        expect(json_response['errors']).not_to be_nil
      end
    end

    context 'authentication failing' do
      it 'returns 401 code' do
        post :create, valid_attrs
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET show' do
    let!(:idea) { create :idea }

    it 'returns the idea json' do
      get :show, { id: idea }.merge(token)
      expect(json_response['id']).to eq idea.id
    end

    it 'returns 404 code if idea is not found' do
      get :show, { id: -1 }.merge(token)
      expect(response.status).to eq 404
    end
  end

  describe 'GET index' do
    let!(:idea) { create :idea }
    let!(:another_idea) { create :idea }

    it 'assigns the ideas' do
      get :index, { per_page: 1, page: 1 }.merge(token)
      expect(assigns(:ideas)).to eq [another_idea]
    end

    it 'returns a ideas json' do
      get :index, { per_page: 1, page: 1 }.merge(token)
      expect(json_response.first['id']).to eq another_idea.id
    end

    it 'response link header includes pagination info' do
      get :index, { per_page: 1, page: 1 }.merge(token)
      expect(response.header['Link']).not_to be_nil
    end
  end

  describe 'PUT vote' do
    let!(:idea) { create :idea }

    it 'let user like the idea' do
      put :vote, { id: idea.id }.merge(token)
      expect(user.liked? idea).to be_truthy
    end
  end

end
