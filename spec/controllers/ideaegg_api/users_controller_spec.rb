require 'rails_helper'

RSpec.describe IdeaeggApi::UsersController, :type => :controller do
  include ApiSpecHelpers
  render_views

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe '#create' do
    it 'creates a new user' do
      expect {
        post :create, attributes_for(:user)
      }.to change { User.count }.by 1
    end

    it 'returns a json' do
      post :create, attributes_for(:user)
      expect(json_response['private_token']).not_to be_nil
    end

    it 'returns 422 code if invalid' do
      post :create , attributes_for(:user, email: nil)
      expect(response.status).to eq 422
      expect(json_response['errors']).not_to be_nil
    end
  end

  describe '#sign_up_temporarily' do
    it 'creates a new user' do
      expect {
        get :sign_up_temporarily
      }.to change { User.count }.by 1
    end

    it 'returns a json' do
      get :sign_up_temporarily
      expect(json_response['private_token']).not_to be_nil
    end
  end

  describe 'GET created_ideas' do
    let(:user) { create :user }
    let!(:idea) { create :idea, user_id: user.id }
    before :each do
      request.env["PRIVATE-TOKEN"] = user.private_token
    end

    it 'assigns the ideas' do
      get :created_ideas
      expect(assigns(:ideas)).to eq [idea]
    end

    it 'returns created ideas json' do
      get :created_ideas
      expect(json_response.size).to eq 1
      expect(json_response.first['id']).to eq idea.id
    end
  end
end
