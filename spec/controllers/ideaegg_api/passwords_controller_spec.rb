require 'rails_helper'

RSpec.describe IdeaeggApi::PasswordsController, :type => :controller do
  include ApiSpecHelpers
  render_views

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#create' do
    let!(:user) { create :user }
    let(:email) { { email: user.email } }

    it 'succeeds if email exists' do
      post :create, { user: email, format: :json }
      expect(json_response['errors']).to be_nil
    end

    it 'fails if email exists' do
      post :create, { user: { email: 'wrong_email@qq.com' }, format: :json }
      expect(json_response['errors']).not_to be_nil
    end

  end
end