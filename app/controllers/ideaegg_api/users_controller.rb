class IdeaeggApi::UsersController < IdeaeggApi::ApplicationController

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

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
