require 'rails_helper'

RSpec.describe IdeaeggApi::PasswordsController, :type => :controller do
  include ApiSpecHelpers
  render_views

  before do
    @request.headers["devise.mapping"] = Devise.mappings[:user]
    request.headers["HTTP_ACCEPT"] = 'application/json'
  end

  describe '#create' do
    let!(:user) { create :user }
    let(:email) { { email: user.email } }

    it 'succeeds if email exists' do
      post :create, email
      expect(response.status).to eq 204
    end

    it 'fails if email exists' do
      post :create, { email: 'wrong_email@qq.com' }
      expect(json_response['errors']).not_to be_nil
    end

  end
end