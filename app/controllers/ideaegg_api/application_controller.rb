class IdeaeggApi::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: "not found" }, status: 404
  end

  private

  def render_json_error(obj = nil)
    if obj.present?
      render json: { errors: obj.errors.full_messages }, status: :unprocessable_entity
    else
      render json: { errors: ['参数错误'] }, status: :unprocessable_entity
    end
  end

  def error_messages(obj)
    obj.errors.full_messages.join('，')
  end

  def authenticate_user_from_token!
    private_token = params[:private_token] || request.env['PRIVATE-TOKEN']
    @user = User.find_by(authentication_token: private_token)
    render json: { message: "401 Unauthorized" }, status: 401 unless @user
  end

end