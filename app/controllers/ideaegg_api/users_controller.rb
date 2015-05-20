class IdeaeggApi::UsersController < IdeaeggApi::ApplicationController

  def create
    @user = User.new(user_params)
    if @user.save
      render :create, layout: false
    else
      render_json_error(@user)
    end
  end

  def auto_create
    @user = User.generate_one_user
    @user.save
    render :create, layout: false
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
