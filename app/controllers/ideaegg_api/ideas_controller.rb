class IdeaeggApi::IdeasController < IdeaeggApi::ApplicationController
  include IdeasHelper

  before_action :authenticate_user_from_token!
  before_action :find_idea, only: [:show, :vote, :unvote, :star, :unstar]
  before_action :find_own_idea, only: [:tags, :cancel_tags]

  def create
    @idea = @user.ideas.build(idea_params)
    if @idea.save
      render status: 201
    else
      render json: { errors: error_messages(@idea) }, status: 422
    end
  end

  def show
  end

  def index
    @ideas = paginate Idea.order_created_desc
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

  def tags
    @idea.tag_list.add(params[:tag], parse: true)
    @idea.save
    @tags = ActsAsTaggableOn::Tag.where(name: params[:tag].split(','))
    render 'ideaegg_api/tags/index'
  end

  def cancel_tags
    @idea.tag_list.remove(params[:tag], parse: true)
    @idea.save
    @tags = ActsAsTaggableOn::Tag.where(name: params[:tag].split(','))
    render 'ideaegg_api/tags/index'
  end

  private

  def idea_params
    params.permit(:title, :cover, :summary, :content)
  end

  def find_idea
    @idea = Idea.find(params[:id])
  end

  def find_own_idea
    @idea = @user.ideas.find(params[:idea_id])
  end
end
