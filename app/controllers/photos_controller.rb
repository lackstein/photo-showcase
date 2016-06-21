class PhotosController < ApplicationController
  before_action :require_login, only: [:like, :dislike]

  def index
    @top_100_photos = FiveHundredPX.public_top_100(image_size: '3,440,1080')['photos']
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
end
