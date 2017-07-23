require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index when logged in as a regular user" do
    log_in_as_regular_user
    get jobs_path
    assert_interpreter_dashboard_present_alone
  end

  # test "should get index when logged in as a manager user with manager dashboard" do
  #   log_in_as_manager
  #   get jobs_path
  #   assert_template :index
  #   assert_manager_dashboard_present_alone
  # end

  # test "should get index when logged in as an admin user with manager dashboard" do
  #   log_in_as_admin
  #   get jobs_path
  #   assert_template :index
  #   assert_manager_dashboard_present_alone
  # end

  test "should redirect index when not logged in" do
    get jobs_path
    assert_flash_and_login_url_redirect
  end

  test "should redirect index when logged in as a customer" do
    log_in_as_customer
    get jobs_path
    assert_flash_and_login_url_redirect
  end
end
