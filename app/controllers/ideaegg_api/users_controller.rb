class IdeaeggApi::UsersController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!, only: [:show, :update]

  def create
    @user = User.new(user_params)
    if @user.save
      render :create, layout: false
    else
      render_json_error(@user)
    end
  end

  def sign_up_temporarily
    @user = User.build_with_attributes
    @user.save
    render :create, layout: false
  end

  def show
    @user = params[:id] ? User.find(params[:id]) : @user
    render :show, layout: false
  end

  def update
    if @user.update update_user_params
      render :show, layout: false
    else
      render_json_error(@user)
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  def update_user_params
    params.permit(:fullname, :avatar, :phone_number)
  end
end
