require 'rails_helper'

RSpec.describe IdeaeggApi::CommentsController, :type => :controller do
  include ApiSpecHelpers
  render_views

  let!(:user) { create :user }
  let!(:idea) { create :idea }

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
    request.env["PRIVATE-TOKEN"] = user.private_token
  end

  describe 'POST create' do
    let(:valid_attrs) { attributes_for :comment }
    let(:invalid_attrs) { attributes_for :comment, body: nil }

    context 'when succeeding' do
      it 'create a new comment' do
        expect {
          post :create, valid_attrs.merge!({ idea_id: idea.id })
        }.to change { idea.comment_threads.count }.by 1
      end

      it 'returns a comment json' do
        post :create, valid_attrs.merge!({ idea_id: idea.id })
        expect(json_response['body']).to eq valid_attrs[:body]
      end
    end

    context 'when failing' do
      it 'returns 422' do
        post :create, invalid_attrs.merge!({ idea_id: idea.id })
        expect(response.status).to eq 422
      end
    end
  end

  describe 'GET index' do
    let!(:comment) { create :comment, commentable: idea }
    let!(:another_comment) { create :comment, commentable: idea }

    it 'assigns the comments' do
      get :index, idea_id: idea.id
      expect(assigns(:comments)).to eq [another_comment, comment]
    end

    it 'returns comments json' do
      get :index, idea_id: idea.id
      expect(json_response.size).to eq 2
    end
  end
end
