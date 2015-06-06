class IdeaeggApi::IdeasController < IdeaeggApi::ApplicationController
  include IdeasHelper

  before_action :authenticate_user_from_token!
  before_action :find_idea, only: [:show, :vote, :unvote, :star, :unstar]

  def create
    @idea = @user.ideas.build(idea_params)
    if @idea.save
      render status: 201
    else
      render_json_error(@idea)
    end
  end

  def show
  end

  def index
    if params[:tag].present?
      @ideas = paginate Idea.tagged_with(params[:tag].split(','), match_all: true)
    else
      @ideas = paginate Idea.order_created_desc
    end
  end

  def vote
    like_idea(@user, @idea)
    render :show
  end

  def unvote
    unlike_idea(@user, @idea)
    render :show
  end

  def star
    star_idea(@user, @idea)
    render :show
  end

  def unstar
    unstar_idea(@user, @idea)
    render :show
  end

  def voted
    @ideas = paginate @user.voted_ideas.reorder("'votes'.'created_at' DESC")
    render :index
  end

  def starred
    @ideas = paginate @user.starred_ideas.reorder("'stars'.'created_at' DESC")
    render :index
  end

  def created
    @ideas = paginate @user.ideas
    render :index
  end

  private

  def idea_params
    params.permit(:title, :cover, :summary, :content)
  end

  def find_idea
    @idea = Idea.find(params[:id])
  end
end
