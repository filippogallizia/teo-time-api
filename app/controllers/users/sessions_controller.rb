# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  def me
    if current_user
      res = { user: current_user }
      respond_with res
    else
      res = { 'user': nil }
      respond_with res
    end
  end

  def list
    if params['only_trainers'] == 'true'
      respond_with User.where(role_id: 2)
    else
      respond_with User.all
    end
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
