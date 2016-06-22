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
end
