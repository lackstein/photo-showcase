class PhotosController < ApplicationController
  before_action :require_login, only: [:like, :dislike]
  rescue_from OAuth2::Error, with: :handle_oauth_error

  def index
    @top_100_photos = get_scoped_photos(image_size: '3,440,1080')['photos']
  rescue => e
    @top_100_photos = []
    flash[:danger] = e.message
  end

  %w(like dislike).each do |action|
    define_method(action) do
      current_user.send(action, params[:id])
      render partial: 'toggle_liked', locals: { photo_id: params[:id] }
    end
  end

  private
  def require_login
    unless logged_in?
      render partial: 'log_in_like_tooltip', locals: { photo_id: params[:id] }, status: 401
    end
  end

  def handle_oauth_error(exception)
    case exception.response.status
    when 401
      session[:oauth_token] = nil
      flash[:danger] = "You've been logged out"
    else
      flash[:danger] = "#{exception.code}"
    end

    render partial: 'alerts', status: exception.response.status
  end

  # If a user is logged in, we want to be able to indicate
  # whether or not they've already liked a photo
  def get_scoped_photos(opts)
    if logged_in?
      current_user.photos(opts)
    else
      FiveHundredPX.photos(opts)
    end
  end
end
