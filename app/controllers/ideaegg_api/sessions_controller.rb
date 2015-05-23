class IdeaeggApi::SessionsController < IdeaeggApi::ApplicationController
  before_action :check_provider, only: [:create_by_provider]

  def create
    @user = User.find_for_database_authentication(login: params[:login])

    if @user && @user.valid_password?(params[:password])
      render :create, layout: false
    else
      render json: { errors: ["帐号或者密码错误"] }, status: 401
    end
  end

  def create_by_provider
    authentication = Authentication.find_by(provider: params[:provider], uid: params[:uid])
    if authentication
      @user = authentication.user
      render :create, layout: false
    else
      @user = User.build_with_authentication params
      if @user.save
        render :create, layout: false
      else
        errors = @user.authentications.first.errors.any? ? error_messages(@user.authentications.first) : error_messages(@user)
        render json: { errors: errors }, status: 422
      end
    end
  end

  private

  def check_provider
    render json: { errors: "授权类型不支持" }, status: 422 unless params[:provider].in? Authentication::PROVIDER_TYPE
  end
end
