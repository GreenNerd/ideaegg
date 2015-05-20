require 'rails_helper'

RSpec.describe IdeaeggApi::SessionsController, :type => :controller do
  include ApiSpecHelpers
  render_views

  describe '#create' do
    let(:password) { 'test-password' }
    let!(:user) { create :user, password: password }
    let(:valid_email_and_password) { { login: user.email, password: password } }
    let(:valid_username_and_password) { { login: user.username, password: password } }
    let(:invalid_login_and_password) { { login: user.username, password: 'wrong-password' } }

    it 'returns 200 code if valid username and password' do
      post :create, valid_username_and_password.merge(format: :json)
      expect(response.status).to eq 200
    end

    it 'returns 200 code if valid email and password' do
      post :create, valid_email_and_password.merge(format: :json)
      expect(response.status).to eq 200
    end

    it 'returns a json if succeeding' do
      post :create, valid_username_and_password.merge(format: :json)
      expect(json_response['private_token']).not_to be_nil
    end

    it 'returns 401 code if invalid' do
      post :create , invalid_login_and_password.merge(format: :json)
      expect(response.status).to eq 401
      expect(json_response['errors']).not_to be_nil
    end
  end
end
