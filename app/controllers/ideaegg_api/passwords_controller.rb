class IdeaeggApi::PasswordsController < Devise::PasswordsController
  protect_from_forgery with: :null_session
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    respond_to do |format|
      if successfully_sent?(resource)
        format.html { respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name)) }
        format.json { render json: { success: true }, layout: false }
      else
        format.html { respond_with(resource) }
        format.json { render json: { errors: resource.errors.full_messages.join('，') }, status: 422 }
      end
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
