class SessionsController < ApplicationController
  def new
    redirect_to FiveHundredPX.oauth_login_url
  end

  def create
    session[:oauth_token] = FiveHundredPX.oauth_token_from_code(params[:code])
    flash[:success] = "You've logged in"
  rescue OAuth2::Error => exception
    flash[:danger] = "#{exception.code}"
  ensure
    redirect_to root_path
  end

  def destroy
    session[:oauth_token] = nil
    flash[:info] = "You've logged out"

    redirect_to root_path
  end
end
