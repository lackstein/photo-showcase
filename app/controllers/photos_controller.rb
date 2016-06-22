class PhotosController < ApplicationController
  before_action :require_login, only: [:like, :dislike]

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
      render partial: 'log_in_like_tooltip', locals: { photo_id: params[:id] }
    end
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
