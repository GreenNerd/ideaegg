class IdeaeggApi::UserController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!

  def show
  end

  def update
    if @user.update update_user_params
      render :show
    else
      render_json_error(@user)
    end
  end

  def update_password
    if @user.valid_password?(params[:current_password])
      if @user.update update_password_params
        render :show
      else
        render json: { errors: error_messages(@user) }, status: 422
      end
    else
      render json: { errors: '密码错误。' }, status: 422
    end
  end


  private

  def update_user_params
    params.permit(:fullname, :avatar, :phone_number)
  end

  def update_password_params
    params.permit(:password, :password_confirmation)
  end
end
