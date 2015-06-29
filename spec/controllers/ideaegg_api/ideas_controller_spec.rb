require 'rails_helper'

RSpec.describe IdeaeggApi::IdeasController, :type => :controller do
  include ApiSpecHelpers
  render_views

  let!(:user) { create :user }

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
    request.env["PRIVATE-TOKEN"] = user.private_token
  end

  describe '#create' do
    let(:valid_attrs) { attributes_for :idea }
    let(:invalid_attrs) { attributes_for :idea, title: nil }
    let(:token) { { private_token: user.private_token } }

    context 'succeeding' do
      it 'creates a idea with token in params' do
        request.env["PRIVATE-TOKEN"] = nil
        expect {
          post :create, valid_attrs.merge!(token)
        }.to change { Idea.count }.by 1
      end

      it 'creates a idea with token in header' do
        expect {
          post :create, valid_attrs
        }.to change { Idea.count }.by 1
      end

      it 'returns a idea json' do
        post :create, valid_attrs
        expect(json_response['content_html']).to eq "<p><strong>World</strong></p>\n"
      end
    end

    context 'validation failing' do
      it 'returns 422 code' do
        post :create, invalid_attrs
        expect(response.status).to eq 422
      end

      it 'returns errors json' do
        post :create, invalid_attrs
        expect(json_response['errors']).not_to be_nil
      end
    end

    context 'authentication failing' do
      it 'returns 401 code' do
        request.env["PRIVATE-TOKEN"] = nil
        post :create, valid_attrs
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET show' do
    let!(:idea) { create :idea }

    it 'returns the idea json' do
      get :show, id: idea
      expect(json_response['id']).to eq idea.id
    end

    it 'returns 404 code if idea is not found' do
      get :show, id: -1
      expect(response.status).to eq 404
    end
  end

  describe 'GET index' do
    let!(:idea) { create :idea }
    let!(:another_idea) { create :idea }

    context 'when params tag not existing' do
      it 'assigns the ideas' do
        get :index, { per_page: 1, page: 1 }
        expect(assigns(:ideas)).to eq [another_idea]
      end

      it 'returns a ideas json' do
        get :index, { per_page: 1, page: 1 }
        expect(json_response.first['id']).to eq another_idea.id
      end

      it 'response link header includes pagination info' do
        get :index, { per_page: 1, page: 1 }
        expect(response.header['Link']).not_to be_nil
      end
    end

    context 'when params tag existing' do
      before do
        idea.tag_list.add("test_tag")
        idea.save
      end

      it 'returns ideas by tag' do
        get :index, { tag: 'test_tag' }
        expect(json_response.size).to eq 1
        expect(json_response.first['id']).to eq idea.id
      end
    end
  end

  describe 'PUT update' do
    let!(:idea) { create :idea, author: user }
    let!(:another_idea) { create :idea }
    let(:valid_attrs) { attributes_for :idea, title: 'another_title' }
    let(:invalid_attrs) { attributes_for :idea, title: nil }

    context 'when succeeding' do
      it 'updates the idea' do
        put :update, valid_attrs.merge!({ id: idea.id })
        idea.reload
        expect(idea.title).to eq 'another_title'
      end
    end

    context 'when failing with invalid_attrs' do
      it 'returns 422' do
        put :update, invalid_attrs.merge!({ id: idea.id })
        expect(response.status).to eq 422
      end
    end

    context 'when failing that modifys the idea not belong to own' do
      it 'returns 403' do
        put :update, valid_attrs.merge!({ id: another_idea.id })
        expect(response.status).to eq 403
      end
    end
  end

  describe 'PUT vote' do
    let!(:idea) { create :idea }

    it 'let user like the idea' do
      put :vote, { id: idea.id }
      expect(user.liked? idea).to be_truthy
    end
  end

  describe 'Delete unvote' do
    let!(:idea) { create :idea }

    before :each do
      user.likes idea
    end

    it 'let user unlike the idea' do
      delete :unvote, { id: idea.id }
      expect(user.liked? idea).to be_falsey
    end
  end

  describe 'PUT star' do
    let!(:idea) { create :idea }

    it 'let user star the idea' do
      put :star, { id: idea.id }
      expect(idea.starred_by? user).to be_truthy
    end
  end

  describe 'DELETE star' do
    let!(:idea) { create :idea }

    before :each do
      idea.starred_by! user
    end

    it 'unstars the idea' do
      delete :unstar, { id: idea.id }
      expect(idea.starred_by? user).to be_falsey
    end
  end

  describe 'GET voted' do
    let(:idea) { create :idea }
    let(:another_idea) { create :idea }

    before :each do
      user.likes idea
      user.likes another_idea
    end

    it 'assigns the ideas' do
      get :voted
      expect(assigns(:ideas)).to eq [another_idea, idea]
    end

    it 'returns voted ideas json' do
      get :voted
      expect(json_response.size).to eq 2
      expect(json_response.first['id']).to eq another_idea.id
    end
  end

  describe 'GET starred' do
    let(:idea) { create :idea }
    let(:another_idea) { create :idea }

    before :each do
      idea.starred_by! user
      another_idea.starred_by! user
    end

    it 'assigns the ideas' do
      get :starred
      expect(assigns(:ideas)).to eq [another_idea, idea]
    end

    it 'returns voted ideas json' do
      get :starred
      expect(json_response.size).to eq 2
      expect(json_response.first['id']).to eq another_idea.id
    end
  end

  describe 'GET created' do
    let!(:idea) { create :idea, user_id: user.id }

    it 'assigns the ideas' do
      get :created
      expect(assigns(:ideas)).to eq [idea]
    end

    it 'returns created ideas json' do
      get :created
      expect(json_response.size).to eq 1
      expect(json_response.first['id']).to eq idea.id
    end
  end
end
