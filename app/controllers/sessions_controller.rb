class SessionsController < ApplicationController
  def new
    redirect_to FiveHundredPX.oauth_login_url
  end

  def create
    session[:oauth_token] = FiveHundredPX.oauth_token_from_code(params[:code])
    flash[:success] = "You've logged in"

    redirect_to root_path
  end

  def destroy
    session[:oauth_token] = nil
    flash[:info] = "You've logged out"

    redirect_to root_path
  end
end
