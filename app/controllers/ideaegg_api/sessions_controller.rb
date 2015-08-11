class IdeaeggApi::SessionsController < IdeaeggApi::ApplicationController
  before_action :check_provider, only: [:create_by_provider]

  def create
    @user = User.find_for_database_authentication(login: params[:login])

    if @user && @user.valid_password?(params[:password])
      render 'ideaegg_api/user/show'
    else
      render_json_error('帐号或者密码错误', 401)
    end
  end

  def create_by_provider
    authentication = Authentication.find_by(provider: params[:provider], uid: params[:uid])
    if authentication
      @user = authentication.user
      render 'ideaegg_api/user/show'
    else
      @user = User.build_with_authentication params
      if @user.save
        render 'ideaegg_api/user/show'
      else
        render_json_error(@user)
      end
    end
  end

  private

  def check_provider
    render_json_error('授权类型不支持') unless params[:provider].in? Authentication::PROVIDER_TYPE
  end
end
