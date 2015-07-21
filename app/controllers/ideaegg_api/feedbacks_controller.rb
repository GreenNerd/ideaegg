class IdeaeggApi::FeedbacksController < IdeaeggApi::ApplicationController
  before_action :find_product

  def create
    @feedback = @product.feedbacks.build feedback_params
    if @feedback.save
      render statsu: 201
    else
      render_json_error(@feedback)
    end
  end

  private

  def find_product
    @product = Product.find(params[:product_id])
  end

  def feedback_params
    params.permit(:body, :stars, { images: [] }, :contact, :anonymous)
  end
end
