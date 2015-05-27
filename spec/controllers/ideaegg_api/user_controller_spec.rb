require 'rails_helper'

RSpec.describe IdeaeggApi::UserController, :type => :controller do
  include ApiSpecHelpers
  render_views

  let!(:user) { create :user }

  before :each do
    request.env["PRIVATE-TOKEN"] = user.private_token
    request.env["HTTP_ACCEPT"] = 'application/json'
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
end
