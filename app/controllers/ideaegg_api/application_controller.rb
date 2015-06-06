class IdeaeggApi::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do
    render_json_error("not found", 404)
  end

  private

  def render_json_error(obj = nil, status = 422)
    if obj.respond_to?(:errors)
      render json: { errors: error_messages(obj) }, status: status
    else
      render json: { errors: obj }, status: status
    end
  end

  def error_messages(obj)
    obj.errors.full_messages.join('，')
  end

  def authenticate_user_from_token!
    private_token = params[:private_token] || request.env['PRIVATE-TOKEN']
    @user = User.find_by(authentication_token: private_token)
    render json: { message: "401 Unauthorized" }, status: 401 unless @user
  end

  def paginate objects
    per_page = (params[:per_page] || Kaminari.config.default_per_page).to_i
    page = (params[:page] || 1).to_i
    paginated_objects = objects.page(page).per(per_page)
    add_pagination_headers paginated_objects, per_page
    paginated_objects
  end

  def add_pagination_headers(paginated, per_page)
    request_url = request.url.split('?').first

    links = []
    links << %(<#{request_url}?page=#{paginated.current_page - 1}&per_page=#{per_page}>; rel="prev") unless paginated.first_page?
    links << %(<#{request_url}?page=#{paginated.current_page + 1}&per_page=#{per_page}>; rel="next") unless paginated.last_page?
    links << %(<#{request_url}?page=1&per_page=#{per_page}>; rel="first")
    links << %(<#{request_url}?page=#{paginated.total_pages}&per_page=#{per_page}>; rel="last")

    response.header['Link'] = links.join(', ')
  end

end