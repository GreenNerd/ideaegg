class IdeaeggApi::TagsController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!

  def create
    @tag = ActsAsTaggableOn::Tag.new tag_params
    if @tag.save
      render :create
    else
      render_json_error(@tag)
    end
  end

  def index
    @tags = paginate ActsAsTaggableOn::Tag.order('taggings_count DESC').all
  end

  def query
    @tags = paginate ActsAsTaggableOn::Tag.where("name LIKE ?", "%#{params[:name]}%").order('taggings_count DESC')
    render :index
  end

  private

  def tag_params
    params.permit(:name)
  end
end
