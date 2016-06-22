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
    assert_template 'photos/_log_in_like_tooltip'
  end

  test 'disliking when logged out returns 401' do
    put :dislike, { id: 123, format: :js } # Logged out since no oauth_token
    assert_response 401
    assert_template 'photos/_log_in_like_tooltip'
  end

  test 'liking when logged in is successful' do
    stub_like_request
    put :like, { id: 123, format: :js }, { oauth_token: 'test_access_token' }
    assert_response :success
    assert_template 'photos/_toggle_liked'
  end

  test 'disliking when logged in is successful' do
    stub_dislike_request
    put :dislike, { id: 123, format: :js }, { oauth_token: 'test_access_token' }
    assert_response :success
    assert_template 'photos/_toggle_liked'
  end

  test 'liking a nonexistent photo returns 500' do
    stub_request(:post, 'https://api.500px.com/v1/photos/bad/vote?vote=1')
      .to_return(status: 500)
    put :like, { id: 'bad', format: :js }, { oauth_token: 'test_access_token' }
    assert_response 500
    assert_template 'photos/_alerts'
  end

  test 'disliking a nonexistent photo returns 500' do
    stub_request(:delete, 'https://api.500px.com/v1/photos/bad/vote')
      .to_return(status: 500)
    put :dislike, { id: 'bad', format: :js }, { oauth_token: 'test_access_token' }
    assert_response 500
    assert_template 'photos/_alerts'
  end
end
