require 'test_helper'

class InterpretingRequestsControllerTest < ActionController::TestCase

  test "create should require logged-in user" do
    assert_no_difference 'InterpretingRequest.count' do
      post :create
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'InterpretingRequest.count' do
      delete :destroy, id: interpreting_requests(:one)
    end
    assert_redirected_to login_url
  end
end
