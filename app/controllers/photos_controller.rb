class PhotosController < ApplicationController
  def index
    @top_100_photos = FiveHundredPX.public_top_100(image_size: '3,440,1080')['photos']
  end
end
