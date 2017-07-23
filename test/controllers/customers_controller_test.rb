require 'test_helper'

class CustomersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @customer = customers(:university)
    @other_customer = customers(:hideaway)
    @non_approved_customer = customers(:shady)
    @deactivated_customer = customers(:pizza_hut)
    @regular_user = users(:samson)
    @manager_user = users(:sanchez)
    @admin_user = users(:michael)
    @customer_params = { customer_name: @customer.customer_name,
                         email: @customer.email,
                         contact_first_name: @customer.contact_first_name,
                         contact_last_name: @customer.contact_last_name,
                         mail_address_line_1: @customer.mail_address_line_1,
                         phone_number: @customer.phone_number,
                         contact_phone_number: @customer.contact_phone_number }
    @example_tsha_number = { tsha_number: 777 }
  end

  test "should get index when logged in as a manager user with manager dashboard" do
    log_in_as_manager
    get customers_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test "should get index when logged in as an admin user with manager dashboard" do
    log_in_as_admin
    get customers_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test "should redirect index when not logged in" do
    get customers_path
    assert_flash_and_login_url_redirect
  end

  test "should redirect index when logged in as a regular user" do
    log_in_as_regular_user
    get customers_path
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect index when logged in as a customer" do
    log_in_as_customer
    get customers_path
    assert_flash_and_login_url_redirect
  end

  test "should get show when logged in as correct customer with customer dashboard" do
    log_in_as_customer
    get customer_path(@customer)
    assert_template :show
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should get show when logged in as a manager with manager dashboard" do
    log_in_as_manager
    get customer_path(@customer)
    assert_template :show
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should get show when logged in as an admin with manager dashboard" do
    log_in_as_admin
    get customer_path(@customer)
    assert_template :show
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should redirect show when not logged in" do
    get customer_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect show when logged in as a regular user" do
    log_in_as_regular_user
    get customer_path(@customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect show when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get customer_path(@customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should get new" do
    get customer_signup_path
    assert_successful_application_layout
  end

  test "should get new when logged in as a manager user with manager dashboard" do
    log_in_as_manager
    get customer_signup_path
    assert_template :new
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should get new when logged in as an admin user with manager dashboard" do
    log_in_as_admin
    get customer_signup_path
    assert_template :new
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should get edit when logged in as correct customer with customer dashboard" do
    log_in_as_customer
    get edit_customer_path(@customer)
    assert_template :edit
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should get edit when logged in as a customer with customer dashboard" do
    log_in_as_customer
    get edit_customer_path(@customer)
    assert_template :edit
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should get edit when logged in as a manager user with manager dashboard" do
    log_in_as_manager
    get edit_customer_path(@customer)
    assert_template :edit
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should get edit when logged in as an admin user with manager dashboard" do
    log_in_as_admin
    get edit_customer_path(@customer)
    assert_template :edit
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should redirect edit when not logged in" do
    get edit_customer_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect edit when logged in as a regular user" do
    log_in_as_regular_user
    get edit_customer_path(@customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect edit when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get edit_customer_path(@customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect update when not logged in" do
    patch customer_path(@customer), params: @customer_params
    assert_flash_and_login_url_redirect
  end

  test "should redirect update when logged in as a regular user" do
    log_in_as_regular_user
    patch customer_path(@customer), params: @customer_params
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect update when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    patch customer_path(@customer), params: @customer_params
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Customer.count' do
      delete customer_path(@customer)
    end
    assert_flash_and_login_url_redirect
  end

  test "should redirect destroy when logged in as a regular user" do
    log_in_as_regular_user
    assert_no_difference 'Customer.count' do
      delete customer_path(@customer)
    end
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect destroy when logged in as a regular customer" do
    log_in_as_customer
    assert_no_difference 'Customer.count' do
      delete customer_path(@customer)
    end
    assert_flash_and_login_url_redirect
  end

  test "should redirect destroy when logged in as a manager" do
    log_in_as_manager
    assert_no_difference 'Customer.count' do
      delete customer_path(@customer)
    end
    assert_empty_flash_and_root_url_redirect
  end

  test "should get pending customers when logged in as a manager user with manager dashboard" do
    log_in_as_manager
    get pending_customers_path(@customer)
    assert_template :pending_customers
    assert_manager_dashboard_present_alone
  end

  test "should get pending customers when logged in as an admin user with manager dashboard" do
    log_in_as_admin
    get pending_customers_path(@customer)
    assert_template :pending_customers
    assert_manager_dashboard_present_alone
  end

  test "should redirect pending customers when not logged in" do
    get pending_customers_path
    assert_flash_and_login_url_redirect
  end

  test "should redirect pending customers when logged in as a regular user" do
    log_in_as_regular_user
    get pending_customers_path
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect pending customers when logged in as a customer" do
    log_in_as_customer
    get pending_customers_path
    assert_flash_and_login_url_redirect
  end

  test "should get pending approval when logged in as a customer with customer dashboard" do
    log_in_as_customer
    get pending_approval_path(@customer)
    assert_template :pending_approval
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect pending approval when not logged in" do
    get pending_approval_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect pending approval when logged in as a regular user" do
    log_in_as_regular_user
    get pending_approval_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect pending approval when logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get pending_approval_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect pending approval when logged in as a manager" do
    log_in_as_manager
    get pending_approval_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect pending approval when logged in as an admin" do
    log_in_as_admin
    get pending_approval_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should get approved job requests when logged in as a customer with customer dashboard" do
    log_in_as_customer
    get approved_job_requests_path(@customer)
    assert_template :approved_job_requests
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect approved job requests when not logged in" do
    get approved_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect approved job requests when logged in as a regular user" do
    log_in_as_regular_user
    get approved_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect approved job requests when logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get approved_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect approved job requests when logged in as a manager" do
    log_in_as_manager
    get approved_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect approved job requests when logged in as an admin" do
    log_in_as_admin
    get approved_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should get rejected job requests when logged in as a customer with customer dashboard" do
    log_in_as_customer
    get rejected_job_requests_path(@customer)
    assert_template :rejected_job_requests
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect rejected job requests when not logged in" do
    get rejected_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect rejected job requests when logged in as a regular user" do
    log_in_as_regular_user
    get rejected_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect rejected job requests when logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get rejected_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect rejected job requests when logged in as a manager" do
    log_in_as_manager
    get rejected_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect rejected job requests when logged in as an admin" do
    log_in_as_admin
    get rejected_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should get expired job requests when logged in as a customer with customer dashboard" do
    log_in_as_customer
    get expired_job_requests_path(@customer)
    assert_template :expired_job_requests
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect expired job requests when not logged in" do
    get expired_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect expired job requests when logged in as a regular user" do
    log_in_as_regular_user
    get expired_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect expired job requests when logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get expired_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect expired job requests when logged in as a manager" do
    log_in_as_manager
    get expired_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect expired job requests when logged in as an admin" do
    log_in_as_admin
    get expired_job_requests_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should get expired current jobs when logged in as a customer with customer dashboard" do
    log_in_as_customer
    get current_jobs_path(@customer)
    assert_template :current_jobs
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect current jobs when not logged in" do
    get current_jobs_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect current jobs when not logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get current_jobs_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect completed jobs when not logged in" do
    get completed_jobs_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect completed jobs when not logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get completed_jobs_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect pending jobs when not logged in" do
    get pending_jobs_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect pending jobs when not logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get pending_jobs_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect manager invoices when not logged in" do
    get manager_invoices_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect manager invoices when not logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get manager_invoices_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should get approve account when logged in as a manager user" do
    log_in_as_manager
    get approve_account_customer_path(@non_approved_customer)
    assert_redirected_to pending_customers_url
  end

  test "should get approve account when logged in as an admin user" do
    log_in_as_admin
    get approve_account_customer_path(@non_approved_customer)
    assert_redirected_to pending_customers_url
  end

  test "should redirect approve account when not logged in" do
    get approve_account_customer_path(@non_approved_customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect approve account logged in as a regular user" do
    log_in_as_regular_user
    get approve_account_customer_path(@non_approved_customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect approve account when logged in as a customer" do
    log_in_as_customer
    get approve_account_customer_path(@non_approved_customer)
    assert_flash_and_login_url_redirect
  end

  test "should get deactivate customer when logged in as an admin user" do
    log_in_as_admin
    get deactivate_customer_customer_path(@customer)
    assert_redirected_to customer_url(@customer)
  end

  test "should redirect deactivate customer when not logged in" do
    get deactivate_customer_customer_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect deactivate customer when logged in as a regular user" do
    log_in_as_regular_user
    get deactivate_customer_customer_path(@customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect deactivate customer when logged in as a customer" do
    log_in_as_customer
    get deactivate_customer_customer_path(@customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect deactivate customer when logged in as a manager" do
    log_in_as_manager
    get deactivate_customer_customer_path(@customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect reactivate customer when not logged in" do
    get reactivate_customer_customer_path(@deactivated_customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect reactivate customer when logged in as a regular user" do
    log_in_as_regular_user
    get reactivate_customer_customer_path(@deactivated_customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect reactivate customer when logged in as a customer" do
    log_in_as_customer
    get reactivate_customer_customer_path(@deactivated_customer)
    assert_flash_and_login_url_redirect
  end

  test "should redirect reactivate customer when logged in as a manager" do
    log_in_as_manager
    get reactivate_customer_customer_path(@deactivated_customer)
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect change TSHA number when not logged in" do
    patch change_tsha_number_customer_path(@customer), params: @example_tsha_number
    assert_flash_and_login_url_redirect
  end

  test "should redirect change TSHA number logged in as a regular user" do
    log_in_as_regular_user
    patch change_tsha_number_customer_path(@customer), params: @example_tsha_number
    assert_empty_flash_and_root_url_redirect
  end

  test "should redirect change TSHA number logged in as a customer" do
    log_in_as_customer
    patch change_tsha_number_customer_path(@customer), params: @example_tsha_number
    assert_flash_and_login_url_redirect
  end
end
