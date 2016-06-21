require 'test_helper'
require 'webmock/minitest'

class FiveHundredPXTest < ActiveSupport::TestCase
  test 'loads the top 100 popular photos' do
    expected_response = MultiJson.load(File.read(File.expand_path('../../fixtures/top_100.json', __FILE__)))

    stub_request(:get, 'https://api.500px.com/v1/photos').with(query: hash_including({
      consumer_key: Rails.application.secrets.consumer_key,
      feature: 'popular',
      sort: 'rating'
    })).to_return(body: expected_response.to_json, headers: { 'Content-Type': 'application/json'})

    assert_equal expected_response, FiveHundredPX.public_top_100.parsed_response
  end
end
