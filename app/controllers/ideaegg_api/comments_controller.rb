class IdeaeggApi::CommentsController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!
  before_action :find_idea

  def create
    @comment = Comment.build_from(@idea, @user.id, params[:body])
    if @comment.save
      render :create
    else
      render_json_error(@comment)
    end
  end

  private

  def find_idea
    @idea = Idea.find(params[:idea_id])
  end
end
