require 'test_helper'

class CustomersControllerTest < ActionController::TestCase

  def setup
    @customer = customers(:university)
    @other_customer = customers(:hideaway)
    @regular_user = users(:samson)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect index when not manager" do
    user_log_in_as(@regular_user)
    get :index
    assert_redirected_to root_url
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

  test "should redirect update when not logged in" do
    patch :update, id: @customer, customer: { customer_name: @customer.customer_name,
                                          contact_first_name: @customer.contact_first_name,
                                          contact_last_name: @customer.contact_last_name,
                                          email: @customer.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    get :edit, id: @customer
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong customer" do
    customer_log_in_as(@other_customer)
    patch :update, id: @customer, customer: { customer_name: @customer.customer_name,
                                          contact_first_name: @customer.contact_first_name,
                                          contact_last_name: @customer.contact_last_name,
                                          email: @customer.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a regular customer" do
    customer_log_in_as(@customer)
    assert_no_difference 'Customer.count' do
      delete :destroy, id: @customer
    end
    assert_redirected_to login_url
  end
end
