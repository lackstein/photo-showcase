class FiveHundredPX
  include HTTParty
  base_uri 'https://api.500px.com/v1'
  default_params consumer_key: Rails.application.secrets.consumer_key

  def self.public_top_100(opts = {})
    query = { feature: 'popular', sort: 'rating', image_size: '3', rpp: 100 }.merge(opts)

    photos = get('/photos', query: query)
    raise "500px API is unavailable: #{photos.response.inspect}" unless photos.response.code == '200'

    photos
  end
end
