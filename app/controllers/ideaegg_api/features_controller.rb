class IdeaeggApi::FeaturesController < IdeaeggApi::ApplicationController
  before_action :authenticate_user_from_token!

  def ideas
    @ideas = paginate Idea.sorted_by_votes
    render 'ideaegg_api/ideas/index'
  end
end
