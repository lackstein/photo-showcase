require 'test_helper'

class FiveHundredPXTest < ActiveSupport::TestCase
  test 'loads the top 100 popular photos' do
    expected_response = MultiJson.load(File.read(File.expand_path('../../fixtures/top_100.json', __FILE__)))

    stub_photos_request do |stub|
      stub.to_return(
        body: expected_response.to_json,
        headers: { 'Content-Type': 'application/json'}
      )
    end

    assert_equal expected_response, FiveHundredPX.photos.parsed_response
  end

  test 'raises RuntimeError if unauthenticated photos API fails' do
    stub_photos_request { |stub| stub.to_return(status: 404) }

    assert_raise(RuntimeError) { FiveHundredPX.photos }
  end
end
