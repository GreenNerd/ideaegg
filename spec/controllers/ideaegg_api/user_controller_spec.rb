require 'rails_helper'

RSpec.describe IdeaeggApi::UserController, :type => :controller do
  include ApiSpecHelpers
  render_views

  before :each do
    request.env["PRIVATE-TOKEN"] = user.private_token
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe 'GET show' do
    let!(:user) { create :user }

    it 'shows yourself' do
      get :show
      expect(json_response['id']).to eq user.id
    end
  end
end
