class IdeaeggApi::TagsController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!
  before_action :find_own_idea, only: [:create, :cancel]

  def create
    @idea.tag_list.add(params[:tag], parse: true)
    if @idea.save
      @tags = @idea.tags
      render :index
    else
      errors = @idea.errors.any? ? @idea : "标签长度错误"
      render_json_error(errors)
    end
  end

  def cancel
    @idea.tag_list.remove(params[:tag], parse: true)
    @idea.save
    @tags = @idea.tags
    render :index
  end

  def index
    @tags = paginate ActsAsTaggableOn::Tag.order('taggings_count DESC').all
  end

  def query
    @tags = paginate ActsAsTaggableOn::Tag.where("name LIKE ?", "%#{params[:name]}%").order('taggings_count DESC')
    render :index
  end

  def ideas
    @tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
    @ideas = paginate Idea.tagged_with(@tag.name)
    render 'ideaegg_api/ideas/index'
  end

  private

  def tag_params
    params.permit(:name)
  end

  def find_own_idea
    @idea = @user.ideas.find(params[:idea_id])
  end
end
