class IdeaeggApi::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session

  def render_json_error(obj = nil)
    if obj.present?
      render json: { errors: obj.errors.full_messages }, status: :unprocessable_entity
    else
      render json: { errors: ['参数错误'] }, status: :unprocessable_entity
    end
  end

end