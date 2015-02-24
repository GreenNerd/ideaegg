module API
  # Ideas API
  class Ideas < Grape::API
    before { authenticate! }

    resource :ideas do
      # Get a ideas list for authenticated user
      #
      # Parameters:
      #   none
      #
      # Example Request:
      #   GET /ideas
      get do
        @ideas = paginate Idea.all
        present @ideas, with: Entities::Idea
      end

      # Get a specific idea
      #
      # Parameters:
      #   id (required)
      #
      # Example Request:
      #   GET /ideas/:id
      get ":id" do
        @idea = Idea.find(params[:id])
        present @idea, with: Entities::Idea
      end

      # Create new idea
      #
      # Parameters:
      #   title (required)
      #   content (required)
      # Example Request
      #   POST /ideas
      post do
        required_attributes! [:title, :content]
        attrs = attributes_for_keys([:title, :content])

        @idea = current_user.ideas.build(attrs)
        if @idea.save
          present @idea, with: Entities::Idea
        else
          render_validation_error!(@idea)
        end
      end

      # Update idea
      #
      # Parameters:
      #   title
      #   content
      # Example Request
      #   PUT /ideas/:id
      put ":id" do
        @idea = Idea.find(params[:id])
        not_found!('Idea') unless @idea
        authenticated_as_current_user @idea.author

        attrs = attributes_for_keys [:title, :content]
        if @idea.update_attributes(attrs)
          present @idea, with: Entities::Idea
        else
          render_validation_error!(@idea)
        end
      end

      # Delete idea
      #
      # Parameters:
      #   id (required)
      # Example Request:
      #   DELETE /ideas/:id
      delete ":id" do
        @idea = Idea.find(params[:id])
        not_found!('Idea') unless @idea
        authenticated_as_current_user @idea.author

        render_validation_error!(@idea) unless @idea.destroy
      end

      # Like idea
      #
      # Parameters:
      #   id (required)
      # Example Request
      #   POST /ideas/:id/like
      post ":id/like" do
        @idea = Idea.find(params[:id])
        not_found!('Idea') unless @idea

        like_idea(current_user, @idea)
      end

      # Unlike idea
      #
      # Parameters:
      #   id (required)
      # Example Request
      #   DELETE /ideas/:id/like
      delete ":id/like" do
        @idea = Idea.find(params[:id])
        not_found!('Idea') unless @idea

        unlike_idea(current_user, @idea)
      end

      # Tag idea
      #
      # Parameters:
      #   id (required)
      #   tag
      # Example Request
      #   POST /ideas/:id/tag
      post ":id/tag" do
        @idea = Idea.find(params[:id])
        not_found!('Idea') unless @idea

        @idea.tag_list.add(params[:tag], parse: true)
        @idea.save
      end

      # Untag idea
      #
      # Parameters:
      #   id (required)
      #   tag
      # Example Request
      #   POST /ideas/:id/untag
      post ":id/untag" do
        @idea = Idea.find(params[:id])
        not_found!('Idea') unless @idea

        @idea.tag_list.remove(params[:tag], parse: true)
        @idea.save
      end

      # Star idea
      #
      # Parameters:
      #   id (required)
      # Example Request
      #   POST /ideas/:id/star
      post ":id/star" do
        @idea = Idea.find(params[:id])
        not_found!('Idea') unless @idea

        star_idea(current_user, @idea)
      end

      # Unstar idea
      #
      # Parameters:
      #   id (required)
      # Example Request
      #   DELETE /ideas/:id/star
      delete ":id/star" do
        @idea = Idea.find(params[:id])
        not_found!('Idea') unless @idea

        unstar_idea(current_user, @idea)
      end
    end
  end
end
