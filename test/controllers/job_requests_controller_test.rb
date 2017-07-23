require 'test_helper'

class JobRequestsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @non_active_customer = customers(:apple)
    @job_request = job_requests(:one)
  end

  test "should get index when logged in as a non active customer" do
    customer_log_in_as(@non_active_customer)
    get job_requests_path
    assert_successful_application_layout
  end

  test "should get index when logged in as a customer with customer dashboard" do
    log_in_as_customer
    get job_requests_path
    assert_template :index
    assert_customer_dashboard_present_alone
  end

  test "should get index when logged in as a manager user with manager dashboard" do
    log_in_as_manager
    get job_requests_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test "should get index when logged in as an admin user with manager dashboard" do
    log_in_as_admin
    get job_requests_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test "should redirect index when not logged in" do
    get job_requests_path
    assert_flash_and_login_url_redirect
  end

  test "should redirect index when logged in as a regular user" do
    log_in_as_regular_user
    get job_requests_path
    assert_flash_and_login_url_redirect
  end

  test "should get show when logged in as a customer with customer dashboard" do
    log_in_as_customer
    get job_request_path(@job_request)
    assert_template :show
    assert_customer_dashboard_present_alone
  end

  test "should get show when logged in as a manager user with manager dashboard" do
    log_in_as_manager
    get job_request_path(@job_request)
    assert_template :show
    assert_manager_dashboard_present_alone
  end

  test "should get show when logged in as an admin user with manager dashboard" do
    log_in_as_admin
    get job_request_path(@job_request)
    assert_template :show
    assert_manager_dashboard_present_alone
  end

  test "should redirect show when not logged in" do
    get job_request_path(@job_request)
    assert_flash_and_login_url_redirect
  end

  test "should redirect show when logged in as a regular user" do
    log_in_as_regular_user
    get job_request_path(@job_request)
    assert_flash_and_login_url_redirect
  end

  test "should redirect show when logged in as a non active customer" do
    customer_log_in_as(@non_active_customer)
    get job_request_path(@job_request)
    assert_redirected_to job_requests_url
  end
end
