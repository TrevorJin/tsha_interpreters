require 'test_helper'

class CustomersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @customer = customers(:university)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    # post login_path, session: { email: @customer.email, password: 'password' }
    post login_path, params: { session: { email: @customer.email, password: 'password' } }
    assert customer_is_logged_in?
    assert_redirected_to @customer
    follow_redirect!
    assert_template 'customers/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", customer_path(@customer)
    delete logout_path
    assert_not customer_is_logged_in?
    assert_redirected_to root_url
    # Simulate a customer clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", customer_path(@customer), count: 0
  end

  test "login with remembering" do
    customer_log_in_as(@customer, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    customer_log_in_as(@customer, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
