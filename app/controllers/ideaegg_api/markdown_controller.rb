class IdeaeggApi::MarkdownController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!

  def preview
    content = MarkdownConverter.convert(params[:content])
    render json: { content: content }, layout: false
  end
end
