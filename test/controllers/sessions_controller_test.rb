require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test 'new redirects to 500px' do
    get :new
    assert_response :redirect
  end

  test 'create stores the oauth_token' do
    stub_oauth_token_from_code_request(token: 'abc', code: '123')
    get :create, { code: 123 }
    assert_equal 'abc', session[:oauth_token]
    assert_redirected_to root_path
  end

  test 'destroy removes the oauth_token' do
    delete :destroy
    assert_nil session[:oauth_token]
    assert_redirected_to root_path
  end
end
