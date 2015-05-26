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

  describe 'GET show' do
    let!(:user) { create :user }
    let!(:another_user) { create :user }
    before :each do
      request.env["PRIVATE-TOKEN"] = user.private_token
    end

    it 'show user by id if param id exists' do
      get :show, id: another_user.id
      expect(json_response['id']).to eq another_user.id
    end

    it 'show yourself if param id not exists' do
      get :show
      expect(json_response['id']).to eq user.id
    end

  end

end
