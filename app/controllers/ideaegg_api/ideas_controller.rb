class IdeaeggApi::IdeasController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!

  def create
    @idea = @user.ideas.build(idea_params)
    @idea.content_html = ::MarkdownConverter.convert(params[:content])
    if @idea.save
      render layout: false
    else
      render json: { errors: error_messages(@idea) }, status: 422
    end
  end

  private

  def idea_params
    params.permit(:title, :cover, :summary, :content)
  end
end
