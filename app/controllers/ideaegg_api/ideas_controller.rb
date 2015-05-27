class IdeaeggApi::IdeasController < IdeaeggApi::ApplicationController
  include IdeasHelper

  before_action :authenticate_user_from_token!
  before_action :find_idea, only: [:show, :vote, :unvote, :star, :unstar]

  def create
    @idea = @user.ideas.build(idea_params)
    if @idea.save
      render layout: false, status: 201
    else
      render json: { errors: error_messages(@idea) }, status: 422
    end
  end

  def show
    render layout: false
  end

  def index
    @ideas = paginate Idea.order_created_desc
    render layout: false
  end

  def vote
    like_idea(@user, @idea)
    render json: { success: true }, layout: false
  end

  def unvote
    unlike_idea(@user, @idea)
    render json: { success: true }, layout: false
  end

  def star
    star_idea(@user, @idea)
    render json: { success: true }, layout: false
  end

  def unstar
    unstar_idea(@user, @idea)
    render json: { success: true }, layout: false
  end

  def voted
    idea_ids = (paginate @user.votes_for_idea).map(&:votable_id)
    @ideas = Idea.find idea_ids
    render :index, layout: false
  end

  private

  def idea_params
    params.permit(:title, :cover, :summary, :content)
  end

  def find_idea
    @idea = Idea.find(params[:id])
  end
end
