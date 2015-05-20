class IdeaeggApi::SessionsController < IdeaeggApi::ApplicationController

  def create
    @user = User.find_for_database_authentication(login: params[:login])

    if @user && @user.valid_password?(params[:password])
      render :create, layout: false
    else
      render json: { errors: ["帐号或者密码错误"] }, status: 401
    end
  end
end
