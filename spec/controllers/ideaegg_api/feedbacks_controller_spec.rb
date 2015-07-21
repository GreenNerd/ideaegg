require 'rails_helper'

RSpec.describe IdeaeggApi::FeedbacksController, :type => :controller do
  include ApiSpecHelpers
  render_views

  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
  end

  describe 'POST create' do
    let(:product) { create :product }
    let(:feedback_attrs) { attributes_for :feedback, stars: 1 }
    let(:invalid_feedback_attrs) { attributes_for :feedback, body: nil }

    context 'when succeeding' do
      it 'creates a new feedback' do
        expect {
          post :create , feedback_attrs.merge!({ product_id: product.id })
        }.to change { product.feedbacks.count }.by 1
      end
    end

    context 'when failing' do
      it 'returns 422' do
        post :create , invalid_feedback_attrs.merge!({ product_id: product.id })
        expect(response.status).to eq 422
      end
    end
  end
end
