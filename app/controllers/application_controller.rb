class ApplicationController < ActionController::Base
  respond_to :json
  wrap_parameters format: [:json, :xml, :url_encoded_form, :multipart_form]
  protect_from_forgery unless: -> { request.format.json? }
  # global error handler
  # include Error::ErrorHandler
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

end
