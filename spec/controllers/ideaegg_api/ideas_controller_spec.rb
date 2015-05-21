require 'rails_helper'

RSpec.describe IdeaeggApi::IdeasController, :type => :controller do
  include ApiSpecHelpers
  render_views

  let!(:user) { create :user }
  let(:token_and_format) { { private_token: user.private_token, format: :json } }

  describe '#create' do
    let(:valid_attrs) { attributes_for :idea }
    let(:invalid_attrs) { attributes_for :idea, cover: nil }

    context 'succeeding' do
      it 'creates a idea with token in params' do
        expect {
          post :create, valid_attrs.merge(token_and_format)
        }.to change { Idea.count }.by 1
      end

      it 'creates a idea with token in header' do
        @request.env['PRIVATE-TOKEN'] = user.private_token
        expect {
          post :create, valid_attrs.merge({ format: :json })
        }.to change { Idea.count }.by 1
      end

      it 'returns a idea json' do
        post :create, valid_attrs.merge(token_and_format)
        expect(json_response['content_html']).to eq MarkdownConverter.convert(valid_attrs[:content])
      end
    end

    context 'validation failing' do
      it 'returns 422 code' do
        post :create, invalid_attrs.merge(token_and_format)
        expect(response.status).to eq 422
      end

      it 'returns errors json' do
        post :create, invalid_attrs.merge(token_and_format)
        expect(json_response['errors']).not_to be_nil
      end
    end

    context 'authentication failing' do
      it 'returns 401 code' do
        post :create, valid_attrs.merge({ format: :json })
        expect(response.status).to eq 401
      end
    end
  end

  describe 'GET show' do
    let!(:idea) { create :idea }

    it 'returns the idea json' do
      get :show, { id: idea }.merge(token_and_format)
      expect(json_response['id']).to eq idea.id
    end

    it 'returns 404 code if idea is not found' do
      get :show, { id: -1 }.merge(token_and_format)
      expect(response.status).to eq 404
    end
  end

end
