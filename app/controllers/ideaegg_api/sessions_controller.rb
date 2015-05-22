class IdeaeggApi::SessionsController < IdeaeggApi::ApplicationController
  before_action :check_provider, only: [:create_by_uid]

  def create
    @user = User.find_for_database_authentication(login: params[:login])

    if @user && @user.valid_password?(params[:password])
      render :create, layout: false
    else
      render json: { errors: ["帐号或者密码错误"] }, status: 401
    end
  end

  def create_by_uid
    @user = User.generate_user_with_authentication params
    if @user.save
      render :create, layout: false
    else
      errors = @user.errors.any? ? error_messages(@user) : error_messages(@user.authentications.first)
      render json: { errors: errors }, status: 422
    end
  end

  private

  def check_provider
    render json: { errors: "授权类型不支持" }, status: 422 unless params[:provider].in? Authentication::PROVIDER_TYPE
  end
end
