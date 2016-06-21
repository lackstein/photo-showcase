class SessionsController < ApplicationController
  def new
    redirect_to FiveHundredPX.oauth_login_url
  end

  def create
    session[:oauth_token] = FiveHundredPX.oauth_token_from_code(params[:code])
    flash[:logged_in] = true

    redirect_to root_path
  end
end
