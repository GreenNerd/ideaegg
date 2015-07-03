require 'rails_helper'

RSpec.describe IdeaeggApi::UserController, :type => :controller do
  include ApiSpecHelpers
  render_views

  let!(:user) { create :user }

  before :each do
    request.headers["PRIVATE-TOKEN"] = user.private_token
    request.headers["HTTP_ACCEPT"] = 'application/json'
  end

  describe 'GET show' do
    it 'shows yourself' do
      get :show
      expect(json_response['id']).to eq user.id
    end
  end

  describe 'PUT update' do
    let(:valid_attrs) { { fullname: 'test_name', phone_number: '1324234' } }
    let(:invalid_attrs) { { fullname: nil, phone_number: '123123' } }

    context 'succeeding' do
      it 'updates the user' do
        put :update, valid_attrs
        expect(json_response['fullname']).to eq 'test_name'
      end
    end

    context 'failing' do
      it 'returns 422' do
        put :update, invalid_attrs
        expect(response.status).to eq 422
      end

      it 'returns a errors json' do
        put :update, invalid_attrs
        expect(json_response['errors']).not_to be_nil
      end
    end
  end

  describe 'PUT update_password' do
    let(:user) { create :user, password: 'test_password' }
    let(:valid_attrs) { { current_password: 'test_password', password: 'new_password', password_confirmation: 'new_password' } }
    let(:invalid_attrs){ { current_password: 'wrong_password', password: 'new_password', password_confirmation: 'new_password' } }
    let(:another_invalid_attrs){ { current_password: 'test_password', password: 'new_password', password_confirmation: 'another_new_password' } }

    context 'succeeding' do
      it 'resets password and change private_token' do
        expect {
          put :update_password, valid_attrs
          user.reload
        }.to change { user.private_token }
      end

      it 'returns a user json' do
        put :update_password, valid_attrs
        expect(json_response['private_token']).not_to be_nil
      end
    end

    context 'failing with wrong current password' do
      it 'returns 422' do
        put :update_password, invalid_attrs
        expect(response.status).to eq 422
      end
    end

    context 'failing validation' do
      it 'returns 422' do
        put :update_password, another_invalid_attrs
        expect(response.status).to eq 422
      end
    end
  end
end
