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

  describe 'PUT update' do
    let!(:user) { create :user }
    let(:valid_attrs) { { fullname: 'test_name', phone_number: '1324234' } }
    let(:invalid_attrs) { { fullname: nil, phone_number: '123123' } }
    before :each do
      request.env["PRIVATE-TOKEN"] = user.private_token
    end

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

  describe 'GET voted_ideas' do
    let(:user) { create :user }
    let(:idea) { create :idea }
    before :each do
      request.env["PRIVATE-TOKEN"] = user.private_token
      user.likes idea
    end

    it 'assigns the ideas' do
      get :voted_ideas
      expect(assigns(:ideas)).to eq [idea]
    end

    it 'returns voted ideas json' do
      get :voted_ideas
      expect(json_response.size).to eq 1
      expect(json_response.first['id']).to eq idea.id
    end
  end

end
