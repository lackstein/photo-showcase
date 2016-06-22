require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  test "should get index" do
    expected_response = MultiJson.load(File.read(File.expand_path('../../fixtures/top_100.json', __FILE__)))

    stub_photos_request do |stub|
      stub.to_return(
        body: expected_response.to_json,
        headers: { 'Content-Type': 'application/json'}
      )
    end

    get :index
    assert_response :success
    assert_not_nil assigns(:top_100_photos)
  end

  test 'liking when logged out returns 401' do
    put :like, { id: 123, format: :js } # Logged out since no oauth_token
    assert_response 401
  end

  test 'disliking when logged out returns 401' do
    put :dislike, { id: 123, format: :js } # Logged out since no oauth_token
    assert_response 401
  end

  test 'liking when logged in is successful' do
    stub_like_request
    put :like, { id: 123, format: :js }, { oauth_token: 'test_access_token' }
    assert_response :success
  end

  test 'disliking when logged in is successful' do
    stub_dislike_request
    put :dislike, { id: 123, format: :js }, { oauth_token: 'test_access_token' }
    assert_response :success
  end
end
