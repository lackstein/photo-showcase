class FiveHundredPX
  include HTTParty
  base_uri 'https://api.500px.com/v1'
  default_params consumer_key: Rails.application.secrets.consumer_key

  def self.public_top_100

  end
end
