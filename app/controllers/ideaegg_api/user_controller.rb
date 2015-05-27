class IdeaeggApi::UserController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!

  def show
    render layout: false
  end

  def update
    if @user.update update_user_params
      render :show, layout: false
    else
      render_json_error(@user)
    end
  end

  private

  def update_user_params
    params.permit(:fullname, :avatar, :phone_number)
  end
end
