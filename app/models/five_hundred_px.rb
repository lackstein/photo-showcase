class FiveHundredPX
  include HTTParty
  base_uri 'https://api.500px.com/v1'
  default_params consumer_key: Rails.application.secrets.consumer_key

  attr_reader :access_token

  def self.photos(opts = {})
    query = { feature: 'popular', sort: 'rating', image_size: '3', rpp: 100 }.merge(opts)

    photos = get('/photos', query: query)
    raise "500px API is unavailable: #{photos.response.inspect}" unless photos.response.code == '200'

    photos
  end

  def self.oauth_consumer
    OAuth2::Client.new(
      Rails.application.secrets.consumer_key,
      Rails.application.secrets.consumer_secret,
      site: base_uri,
      authorize_url: '/v1/oauth/authorize',
      token_url: '/v1/oauth/token'
    )
  end

  def self.oauth_login_url
    oauth_consumer.auth_code.authorize_url(redirect_uri: Rails.application.routes.url_helpers.sessions_create_url)
  end

  def self.oauth_token_from_code(code)
    # Exchanges the code received from 500px for a long-term access token which can be used to act on behalf of the user
    oauth_consumer
      .auth_code
      .get_token(code,
        redirect_uri: Rails.application.routes.url_helpers.sessions_create_url)
      .token
  end

  def initialize(token)
    @access_token = OAuth2::AccessToken.new(
      self.class.oauth_consumer,
      token
    )
  end

  def photos(opts = {})
    query = { feature: 'popular', sort: 'rating', image_size: '3', rpp: 100, include_states: 1 }.merge(opts)

    access_token.get('/v1/photos', params: query).parsed
  end

  def like(photo_id)
    access_token.post("/v1/photos/#{photo_id}/vote", params: { vote: 1 })
  end

  def dislike(photo_id)
    access_token.delete("/v1/photos/#{photo_id}/vote")
  end
end
