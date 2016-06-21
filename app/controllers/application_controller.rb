class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #rescue_from OAuth2::Error, with: :log_out
  helper_method :current_user, :logged_in?

  def log_out
    session[:oauth_token] = nil
    flash[:danger] = "You've been logged out"
  end

  def current_user
    return unless session[:oauth_token]
    @current_user ||= FiveHundredPX.new(session[:oauth_token])
  end

  def logged_in?
    !!current_user
  end
end
