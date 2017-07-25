require 'test_helper'

class InterpretingRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @interpreting_request = interpreting_requests(:one)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'InterpretingRequest.count' do
      post interpreting_requests_path
    end
    assert_flash_and_login_url_redirect
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'InterpretingRequest.count' do
      delete interpreting_request_path(@interpreting_request)
    end
    assert_flash_and_login_url_redirect
  end
end
