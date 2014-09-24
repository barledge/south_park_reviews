class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :avatar_url, :name) }
  end

  # If in user controller, you don't have to pass in anything
  # Otherwise, you must pass in user to authenticate action
  # Use before completing any Update/Delete method
  def authorize_user_for_action!(author)
    unless current_user == author
      redirect_to root_path, notice: "Don't Hack This"
    end
  end
end
