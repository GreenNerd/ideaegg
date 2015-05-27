class IdeaeggApi::UserController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!

  def show
    render :show, layout: false
  end

end
