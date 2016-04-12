require 'test_helper'

class CustomersControllerTest < ActionController::TestCase

  def setup
    @customer = customers(:university)
    @other_customer = customers(:hideaway)
    @non_approved_customer = customers(:shady)
    @regular_user = users(:samson)
    @manager_user = users(:sanchez)
    @admin_user = users(:michael)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect index when logged in as a customer" do
    customer_log_in_as(@customer)
    get :index
    assert_redirected_to login_url
  end

  test "should redirect index when not manager" do
    user_log_in_as(@regular_user)
    get :index
    assert_redirected_to root_url
  end

  test "should redirect show when not logged in" do
    get :show, id: @customer
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @customer
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get :edit, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get :edit, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @customer, customer: { customer_name: @customer.customer_name,
                                              email: @customer.email,
                                              contact_first_name: @customer.contact_first_name,
                                              contact_last_name: @customer.contact_last_name,
                                              mail_address_line_1: @customer.mail_address_line_1,
                                              phone_number: @customer.phone_number,
                                              contact_phone_number: @customer.contact_phone_number }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    patch :update, id: @customer, customer: { customer_name: @customer.customer_name,
                                              email: @customer.email,
                                              contact_first_name: @customer.contact_first_name,
                                              contact_last_name: @customer.contact_last_name,
                                              mail_address_line_1: @customer.mail_address_line_1,
                                              phone_number: @customer.phone_number,
                                              contact_phone_number: @customer.contact_phone_number }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as a regular user" do
    user_log_in_as(@regular_user)
    patch :update, id: @customer, customer: { customer_name: @customer.customer_name,
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
      delete :destroy, id: @customer
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a regular user" do
    user_log_in_as(@regular_user)
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a manager" do
    user_log_in_as(@manager_user)
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a regular customer" do
    customer_log_in_as(@customer)
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to login_url
  end

  test "should redirect pending customers when not logged in" do
    get :pending_customers
    assert_redirected_to login_url
  end

  test "should redirect pending customers when logged in as a customer" do
    customer_log_in_as(@customer)
    get :pending_customers
    assert_redirected_to login_url
  end

  test "should redirect pending customers when not manager" do
    user_log_in_as(@regular_user)
    get :pending_customers
    assert_redirected_to root_url
  end

  test "should redirect pending approval when not logged in" do
    get :pending_approval
    assert_redirected_to login_url
  end

  test "should redirect pending approval when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get :pending_approval, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect pending approval when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get :pending_approval
    assert_redirected_to login_url
  end

  test "should redirect pending approval when logged in as a manager" do
    user_log_in_as(@manager_user)
    get :pending_approval
    assert_redirected_to login_url
  end

  test "should redirect pending approval when logged in as an admin" do
    user_log_in_as(@admin_user)
    get :pending_approval
    assert_redirected_to login_url
  end

  test "should redirect approved job requests when not logged in" do
    get :approved_job_requests
    assert_redirected_to login_url
  end

  test "should redirect approved job requests when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get :approved_job_requests, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect approved job requests when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get :approved_job_requests
    assert_redirected_to login_url
  end

  test "should redirect approved job requests when logged in as a manager" do
    user_log_in_as(@manager_user)
    get :approved_job_requests
    assert_redirected_to login_url
  end

  test "should redirect approved job requests when logged in as an admin" do
    user_log_in_as(@admin_user)
    get :approved_job_requests
    assert_redirected_to login_url
  end

  test "should redirect rejected job requests when not logged in" do
    get :rejected_job_requests
    assert_redirected_to login_url
  end

  test "should redirect rejected job requests when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get :rejected_job_requests, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect rejected job requests when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get :rejected_job_requests
    assert_redirected_to login_url
  end

  test "should redirect rejected job requests when logged in as a manager" do
    user_log_in_as(@manager_user)
    get :rejected_job_requests
    assert_redirected_to login_url
  end

  test "should redirect rejected job requests when logged in as an admin" do
    user_log_in_as(@admin_user)
    get :rejected_job_requests
    assert_redirected_to login_url
  end

  test "should redirect expired job requests when not logged in" do
    get :expired_job_requests
    assert_redirected_to login_url
  end

  test "should redirect expired job requests when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get :expired_job_requests, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect expired job requests when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get :expired_job_requests
    assert_redirected_to login_url
  end

  test "should redirect expired job requests when logged in as a manager" do
    user_log_in_as(@manager_user)
    get :expired_job_requests
    assert_redirected_to login_url
  end

  test "should redirect expired job requests when logged in as an admin" do
    user_log_in_as(@admin_user)
    get :expired_job_requests
    assert_redirected_to login_url
  end

  test "should redirect approve account when not logged in" do
    get :approve_account, id: @non_approved_customer
    assert_redirected_to login_url
  end

  test "should redirect approve account when logged in as a customer" do
    customer_log_in_as(@customer)
    get :approve_account, id: @non_approved_customer
    assert_redirected_to login_url
  end

  test "should redirect approve account when not manager" do
    user_log_in_as(@regular_user)
    get :approve_account, id: @non_approved_customer
    assert_redirected_to root_url
  end

  test "should redirect deactivate customer when not logged in" do
    get :deactivate_customer, id: @non_approved_customer
    assert_redirected_to login_url
  end

  test "should redirect deactivate customer when logged in as a customer" do
    customer_log_in_as(@customer)
    get :deactivate_customer, id: @non_approved_customer
    assert_redirected_to root_url
  end

  test "should redirect deactivate customer when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get :deactivate_customer, id: @non_approved_customer
    assert_redirected_to login_url
  end

  test "should redirect deactivate customer when logged in as a manager" do
    user_log_in_as(@manager_user)
    get :deactivate_customer, id: @non_approved_customer
    assert_redirected_to login_url
  end
end
