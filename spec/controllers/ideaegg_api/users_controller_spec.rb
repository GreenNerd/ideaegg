require 'rails_helper'

RSpec.describe IdeaeggApi::UsersController, :type => :controller do
  include ApiSpecHelpers

  describe '#create' do
    render_views

    it 'creates a new user' do
      expect {
        post :create, attributes_for(:user, format: :json)
      }.to change { User.count }.by 1
    end

    it 'returns a json' do
      post :create, attributes_for(:user, format: :json)
      expect(json_response['private_token']).not_to be_nil
    end

    it 'returns 422 code if invalid' do
      post :create , attributes_for(:user, email: nil, format: :json)
      expect(response.status).to eq 422
      expect(json_response['errors']).not_to be_nil
    end
  end

  describe '#auto_create' do
    render_views

    it 'creates a new user' do
      expect {
        get :auto_create, format: :json
      }.to change { User.count }.by 1
    end

    it 'returns a json' do
      get :auto_create, format: :json
      expect(json_response['private_token']).not_to be_nil
    end
  end

end
