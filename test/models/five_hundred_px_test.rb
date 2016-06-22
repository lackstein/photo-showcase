require 'test_helper'

class FiveHundredPXTest < ActiveSupport::TestCase
  test 'loads photos when user not logged in' do
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

  test '.oauth_consumer returns an instance of OAuth2::Client' do
    assert_equal OAuth2::Client, FiveHundredPX.oauth_consumer.class
  end

  test '.oauth_login_url returns a valid URL' do
    assert_match URI::regexp(['http', 'https']), FiveHundredPX.oauth_login_url
  end

  test '.oauth_token_from_code exchanges and oauth code for an access token' do
    stub_request(:post, 'https://api.500px.com/v1/oauth/token')
      .with(body: {
        client_id: Rails.application.secrets.consumer_key,
        client_secret: Rails.application.secrets.consumer_secret,
        code: 'test_oauth_code',
        grant_type: 'authorization_code',
        redirect_uri: Rails.application.routes.url_helpers.sessions_create_url })
      .to_return(
        status: 200,
        body: { access_token: 'test_access_token' }.to_json,
        headers: { 'Content-Type': 'application/json'})

    assert_equal 'test_access_token', FiveHundredPX.oauth_token_from_code('test_oauth_code')
  end

  test 'loads photos when user is logged in' do
    expected_response = MultiJson.load(File.read(File.expand_path('../../fixtures/top_100.json', __FILE__)))

    stub_request(:get, 'https://api.500px.com/v1/photos')
      .with(
        query: hash_including(), # Needed to ignore the query parameters
        headers: {'Authorization'=>'Bearer test_access_token'})
      .to_return(
        body: expected_response.to_json,
        headers: { 'Content-Type': 'application/json'}
      )

    assert_equal expected_response, FiveHundredPX.new('test_access_token').photos
  end

  test 'likes a photo' do
    expected_response = stub_like_request

    assert_equal MultiJson.load(expected_response), FiveHundredPX.new('test_access_token').like(123).parsed
  end

  test 'dislikes a photo' do
    expected_response = stub_dislike_request

    assert_equal MultiJson.load(expected_response), FiveHundredPX.new('test_access_token').dislike(123).parsed
  end
end
