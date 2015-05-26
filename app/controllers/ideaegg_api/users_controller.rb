class IdeaeggApi::UsersController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!, except: [:create, :sign_up_temporarily]

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

  def voted_ideas
    @ideas = paginate @user.all_likes
    render layout: false
  end

  def starred_ideas
    idea_ids = (paginate @user.stars_for_idea).map(&:starrable_id)
    @ideas = Idea.find idea_ids
    render :voted_ideas, layout: false
  end

  def created_ideas
    @ideas = paginate @user.ideas
    render :voted_ideas, layout: false
  end

  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

  def update_user_params
    params.permit(:fullname, :avatar, :phone_number)
  end
end
