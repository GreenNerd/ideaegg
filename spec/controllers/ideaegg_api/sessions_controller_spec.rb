require 'rails_helper'

RSpec.describe IdeaeggApi::SessionsController, :type => :controller do
  include ApiSpecHelpers
  render_views

  before :each do
    request.headers["HTTP_ACCEPT"] = 'application/json'
  end

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

  describe 'POST create_by_provider' do
    let(:valid_attrs) { { uid: FFaker::Guid.guid, provider: 'wechat' } }
    let(:valid_attrs_with_email) { { uid: FFaker::Guid.guid, provider: 'wechat', email: 'test_email@qq.com' } }
    let(:invalid_attrs) { { uid: FFaker::Guid.guid, provider: 'not_exist' } }

    context 'succeeding' do
      it 'returns 200 code' do
        post :create_by_provider, valid_attrs
        expect(response.status).to eq 200
      end

      it 'creates a new user' do
        expect {
          post :create_by_provider, valid_attrs
        }.to change { User.count }.by 1
      end

      it 'returns a user json' do
        post :create_by_provider, valid_attrs
        expect(json_response['private_token']).not_to be_nil
      end

      it 'uses email in params if params include a email' do
        post :create_by_provider, valid_attrs_with_email
        expect(json_response['email']).to eq 'test_email@qq.com'
      end

      it 'directly return the user if authentication exists' do
        user = create :user
        user.authentications.create(uid: 'test_uid', provider: 'wechat')
        post :create_by_provider, { uid: 'test_uid', provider: 'wechat' }
        expect(json_response['private_token']).to eq user.private_token
      end
    end

    context 'failing' do
      it 'returns 422 code' do
        post :create_by_provider, invalid_attrs
        expect(response.status).to eq 422
      end
    end
  end
end
