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
    let(:idea) { create :idea, user_id: user.id }
    let(:another_idea) { create :idea }
    let(:valid_attrs) { { tag: 'name1, name2' } }
    let(:invalid_attrs) { { tag: '标签长度不能超过十个字, 我是五个字' } }

    context 'when succeeding' do
      it 'add two tags for the idea' do
        expect {
          post :create, { idea_id: idea.id }.merge!(valid_attrs)
          idea.reload
        }.to change { idea.tag_list.count }.by 2
      end

      it 'returns 404 if idea not belongs to user' do
        post :create, { idea_id: another_idea }.merge!(valid_attrs)
        expect(response.status).to eq 404
      end
    end

    context 'when failing' do
      it 'returns 422' do
        post :create, { idea_id: idea.id }.merge!(invalid_attrs)
        expect(response.status).to eq 422
      end
    end
  end

  describe 'DELETE cancel' do
    let(:idea) { create :idea, user_id: user.id }
    let(:tag_params) { { tag: 'name1, name2' } }
    let(:another_idea) { create :idea }

    before :each do
      idea.tag_list.add("name1, name2", parse: true)
      idea.save
    end

    it 'cancel two tags for the idea' do
      expect {
        post :cancel, { idea_id: idea.id }.merge!(tag_params)
        idea.reload
      }.to change { idea.tag_list.count }.by -2
    end

    it 'returns 404 if idea not belongs to user' do
      post :cancel, { idea_id: another_idea }.merge!(tag_params)
      expect(response.status).to eq 404
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
      get :query, query_attr
      expect(json_response.first['name']).to eq '中文名字'
    end
  end
end
