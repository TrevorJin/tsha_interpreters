require 'test_helper'

class InterpretingRequestsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @interpreting_request = interpreting_requests(:one)
  end

  test "create should require logged-in user" do
    assert_no_difference 'InterpretingRequest.count' do
      post interpreting_requests_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'InterpretingRequest.count' do
      delete interpreting_request_path(@interpreting_request)
    end
    assert_redirected_to login_url
  end
end
