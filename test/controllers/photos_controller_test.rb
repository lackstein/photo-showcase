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
end
