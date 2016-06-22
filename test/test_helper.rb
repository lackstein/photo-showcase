ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def stub_photos_request
    stub = stub_request(:get, 'https://api.500px.com/v1/photos').with(query: hash_including(consumer_key: Rails.application.secrets.consumer_key))

    yield stub if block_given?
  end

  def stub_like_request
    expected_response = File.read(File.expand_path('../fixtures/photo.json', __FILE__))

    stub = stub_request(:post, 'https://api.500px.com/v1/photos/123/vote?vote=1')
      .to_return(
        body: expected_response,
        headers: { 'Content-Type': 'application/json'})

    yield stub if block_given?

    expected_response
  end

  def stub_dislike_request
    expected_response = File.read(File.expand_path('../fixtures/photo.json', __FILE__))

    stub = stub_request(:delete, 'https://api.500px.com/v1/photos/123/vote')
      .to_return(
        body: expected_response,
        headers: { 'Content-Type': 'application/json'})

    yield stub if block_given?

    expected_response
  end

  def stub_oauth_token_from_code_request(token:, code:)
    stub = stub_request(:post, 'https://api.500px.com/v1/oauth/token')
      .with(body: {
        client_id: Rails.application.secrets.consumer_key,
        client_secret: Rails.application.secrets.consumer_secret,
        code: code,
        grant_type: 'authorization_code',
        redirect_uri: Rails.application.routes.url_helpers.sessions_create_url })
      .to_return(
        status: 200,
        body: { access_token: token }.to_json,
        headers: { 'Content-Type': 'application/json'})

    yield stub if block_given?
  end
end
