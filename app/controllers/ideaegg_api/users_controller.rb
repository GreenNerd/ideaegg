class IdeaeggApi::UsersController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!, only: [:show]

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

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
