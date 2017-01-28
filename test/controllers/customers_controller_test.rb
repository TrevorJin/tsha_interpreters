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
  end

  test "should get index when logged in as a manager user with manager dashboard" do
    user_log_in_as(@manager_user)
    get customers_path
    assert_response :success
    assert_template :index
    assert_template layout: "layouts/application"
    assert_manager_dashboard_present_alone
  end

  test "should get index when logged in as an admin user with manager dashboard" do
    user_log_in_as(@admin_user)
    get customers_path
    assert_response :success
    assert_template :index
    assert_template layout: "layouts/application"
    assert_manager_dashboard_present_alone
  end

  test "should redirect index when not logged in" do
    get customers_path
    assert_redirected_to login_url
  end

  test "should redirect index when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get customers_path
    assert_redirected_to root_url
  end

  test "should redirect index when logged in as a customer" do
    customer_log_in_as(@customer)
    get customers_path
    assert_redirected_to login_url
  end

  test "should get show when logged in as correct customer with customer dashboard" do
    customer_log_in_as(@customer)
    get customer_path(@customer)
    assert_response :success
    assert_template :show
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should get show when logged in as a manager with manager dashboard" do
    user_log_in_as(@manager_user)
    get customer_path(@customer)
    assert_response :success
    assert_template :show
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should get show when logged in as an admin with manager dashboard" do
    user_log_in_as(@admin_user)
    get customer_path(@customer)
    assert_response :success
    assert_template :show
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should redirect show when not logged in" do
    get customer_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect show when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get customer_path(@customer)
    assert_redirected_to root_url
  end

  test "should redirect show when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get customer_path(@customer)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should get new" do
    get customer_signup_path
    assert_response :success
  end

  test "should get new when logged in as a manager user with manager dashboard" do
    user_log_in_as(@manager_user)
    get customer_signup_path
    assert_response :success
    assert_template :new
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should get new when logged in as an admin user with manager dashboard" do
    user_log_in_as(@admin_user)
    get customer_signup_path
    assert_response :success
    assert_template :new
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should get edit when logged in as correct customer with customer dashboard" do
    customer_log_in_as(@customer)
    get edit_customer_path(@customer)
    assert_response :success
    assert_template :edit
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should get edit when logged in as a customer with customer dashboard" do
    customer_log_in_as(@customer)
    get edit_customer_path(@customer)
    assert_response :success
    assert_template :edit
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should get edit when logged in as a manager user with manager dashboard" do
    user_log_in_as(@manager_user)
    get edit_customer_path(@customer)
    assert_response :success
    assert_template :edit
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should get edit when logged in as an admin user with manager dashboard" do
    user_log_in_as(@admin_user)
    get edit_customer_path(@customer)
    assert_response :success
    assert_template :edit
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_manager_dashboard_present_alone
  end

  test "should redirect edit when not logged in" do
    get edit_customer_path(@customer)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get edit_customer_path(@customer)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get edit_customer_path(@customer)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch customer_path(@customer), params: { customer_name: @customer.customer_name,
                                              email: @customer.email,
                                              contact_first_name: @customer.contact_first_name,
                                              contact_last_name: @customer.contact_last_name,
                                              mail_address_line_1: @customer.mail_address_line_1,
                                              phone_number: @customer.phone_number,
                                              contact_phone_number: @customer.contact_phone_number }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as a regular user" do
    user_log_in_as(@regular_user)
    patch customer_path(@customer), params: { customer_name: @customer.customer_name,
                                              email: @customer.email,
                                              contact_first_name: @customer.contact_first_name,
                                              contact_last_name: @customer.contact_last_name,
                                              mail_address_line_1: @customer.mail_address_line_1,
                                              phone_number: @customer.phone_number,
                                              contact_phone_number: @customer.contact_phone_number }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    patch customer_path(@customer), params: { customer_name: @customer.customer_name,
                                              email: @customer.email,
                                              contact_first_name: @customer.contact_first_name,
                                              contact_last_name: @customer.contact_last_name,
                                              mail_address_line_1: @customer.mail_address_line_1,
                                              phone_number: @customer.phone_number,
                                              contact_phone_number: @customer.contact_phone_number }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Customer.count' do
      delete customer_path(@customer)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a regular user" do
    user_log_in_as(@regular_user)
    assert_no_difference 'Customer.count' do
      delete customer_path(@customer)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a regular customer" do
    customer_log_in_as(@customer)
    assert_no_difference 'Customer.count' do
      delete customer_path(@customer)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a manager" do
    user_log_in_as(@manager_user)
    assert_no_difference 'Customer.count' do
      delete customer_path(@customer)
    end
    assert_redirected_to root_url
  end

  test "should get pending customers when logged in as a manager user with manager dashboard" do
    user_log_in_as(@manager_user)
    get pending_customers_path(@customer)
    assert_response :success
    assert_template :pending_customers
    assert_template layout: "layouts/application"
    assert_manager_dashboard_present_alone
  end

  test "should get pending customers when logged in as an admin user with manager dashboard" do
    user_log_in_as(@admin_user)
    get pending_customers_path(@customer)
    assert_response :success
    assert_template :pending_customers
    assert_template layout: "layouts/application"
    assert_manager_dashboard_present_alone
  end

  test "should redirect pending customers when not logged in" do
    get pending_customers_path
    assert_redirected_to login_url
  end

  test "should redirect pending customers when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get pending_customers_path
    assert_redirected_to root_url
  end

  test "should redirect pending customers when logged in as a customer" do
    customer_log_in_as(@customer)
    get pending_customers_path
    assert_redirected_to login_url
  end

  test "should get pending approval when logged in as a customer with customer dashboard" do
    customer_log_in_as(@customer)
    get pending_approval_path(@customer)
    assert_response :success
    assert_template :pending_approval
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect pending approval when not logged in" do
    get pending_approval_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect pending approval when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get pending_approval_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect pending approval when logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get pending_approval_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect pending approval when logged in as a manager" do
    user_log_in_as(@manager_user)
    get pending_approval_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect pending approval when logged in as an admin" do
    user_log_in_as(@admin_user)
    get pending_approval_path(@customer)
    assert_redirected_to login_url
  end

  test "should get approved job requests when logged in as a customer with customer dashboard" do
    customer_log_in_as(@customer)
    get approved_job_requests_path(@customer)
    assert_response :success
    assert_template :approved_job_requests
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect approved job requests when not logged in" do
    get approved_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect approved job requests when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get approved_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect approved job requests when logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get approved_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect approved job requests when logged in as a manager" do
    user_log_in_as(@manager_user)
    get approved_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect approved job requests when logged in as an admin" do
    user_log_in_as(@admin_user)
    get approved_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should get rejected job requests when logged in as a customer with customer dashboard" do
    customer_log_in_as(@customer)
    get rejected_job_requests_path(@customer)
    assert_response :success
    assert_template :rejected_job_requests
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect rejected job requests when not logged in" do
    get rejected_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect rejected job requests when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get rejected_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect rejected job requests when logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get rejected_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect rejected job requests when logged in as a manager" do
    user_log_in_as(@manager_user)
    get rejected_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect rejected job requests when logged in as an admin" do
    user_log_in_as(@admin_user)
    get rejected_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should get expired job requests when logged in as a customer with customer dashboard" do
    customer_log_in_as(@customer)
    get expired_job_requests_path(@customer)
    assert_response :success
    assert_template :expired_job_requests
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect expired job requests when not logged in" do
    get expired_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect expired job requests when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get expired_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect expired job requests when logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get expired_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect expired job requests when logged in as a manager" do
    user_log_in_as(@manager_user)
    get expired_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect expired job requests when logged in as an admin" do
    user_log_in_as(@admin_user)
    get expired_job_requests_path(@customer)
    assert_redirected_to login_url
  end

  test "should get expired current jobs when logged in as a customer with customer dashboard" do
    customer_log_in_as(@customer)
    get current_jobs_path(@customer)
    assert_response :success
    assert_template :current_jobs
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:customer)
    assert_customer_dashboard_present_alone
  end

  test "should redirect current jobs when not logged in" do
    get current_jobs_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect current jobs when not logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get current_jobs_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect completed jobs when not logged in" do
    get completed_jobs_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect completed jobs when not logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get completed_jobs_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect pending jobs when not logged in" do
    get pending_jobs_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect pending jobs when not logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get pending_jobs_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect manager invoices when not logged in" do
    get manager_invoices_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect manager invoices when not logged in as a deactivated customer" do
    customer_log_in_as(@deactivated_customer)
    get manager_invoices_path(@customer)
    assert_redirected_to login_url
  end

  test "should get approve account when logged in as a manager user" do
    user_log_in_as(@manager_user)
    get approve_account_customer_path(@non_approved_customer)
    assert_redirected_to pending_customers_url
  end

  test "should get approve account when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get approve_account_customer_path(@non_approved_customer)
    assert_redirected_to pending_customers_url
  end

  test "should redirect approve account when not logged in" do
    get approve_account_customer_path(@non_approved_customer)
    assert_redirected_to login_url
  end

  test "should redirect approve account logged in as a regular user" do
    user_log_in_as(@regular_user)
    get approve_account_customer_path(@non_approved_customer)
    assert_redirected_to root_url
  end

  test "should redirect approve account when logged in as a customer" do
    customer_log_in_as(@customer)
    get approve_account_customer_path(@non_approved_customer)
    assert_redirected_to login_url
  end

  test "should get deactivate customer when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get deactivate_customer_customer_path(@customer)
    assert_redirected_to customer_url(@customer)
  end

  test "should redirect deactivate customer when not logged in" do
    get deactivate_customer_customer_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect deactivate customer when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get deactivate_customer_customer_path(@customer)
    assert_redirected_to root_url
  end

  test "should redirect deactivate customer when logged in as a customer" do
    customer_log_in_as(@customer)
    get deactivate_customer_customer_path(@customer)
    assert_redirected_to login_url
  end

  test "should redirect deactivate customer when logged in as a manager" do
    user_log_in_as(@manager_user)
    get deactivate_customer_customer_path(@customer)
    assert_redirected_to root_url
  end

  test "should redirect reactivate customer when not logged in" do
    get reactivate_customer_customer_path(@deactivated_customer)
    assert_redirected_to login_url
  end

  test "should redirect reactivate customer when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get reactivate_customer_customer_path(@deactivated_customer)
    assert_redirected_to root_url
  end

  test "should redirect reactivate customer when logged in as a customer" do
    customer_log_in_as(@customer)
    get reactivate_customer_customer_path(@deactivated_customer)
    assert_redirected_to login_url
  end

  test "should redirect reactivate customer when logged in as a manager" do
    user_log_in_as(@manager_user)
    get reactivate_customer_customer_path(@deactivated_customer)
    assert_redirected_to root_url
  end
end
