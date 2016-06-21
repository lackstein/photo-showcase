module PhotosHelper
  def toggle_liked_path(photo_id, liked)
    liked ? photos_dislike_path(id: photo_id) : photos_like_path(id: photo_id)
  end
end
