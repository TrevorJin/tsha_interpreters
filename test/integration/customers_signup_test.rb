require 'test_helper'

class CustomersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get customer_signup_path
    assert_no_difference 'Customer.count' do
      post customers_path, customer: { customer_name:  "",
      												 contact_first_name:  "",
                               contact_last_name: "",
                               email: "user@invalid",
                               phone_number: "",
                               contact_phone_number: "",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'customers/new'
  end

  test "valid signup information with account activation" do
    get customer_signup_path
    assert_difference 'Customer.count', 1 do
      post customers_path, customer: { customer_name:  "Pasta Palace",
      												 contact_first_name:  "Peter",
                               contact_last_name: "Pasta",
                               email: "peterpasta@pastapalace.com",
                               phone_number: "+18662466453",
                               contact_phone_number: "+18662466453",
                               password:              "password",
                               password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    customer = assigns(:customer)
    assert_not customer.activated?
    # Try to log in before activation.
    customer_log_in_as(customer)
    assert_not customer_is_logged_in?
    # Invalid activation token
    get edit_customer_account_activation_path("invalid token")
    assert_not customer_is_logged_in?
    # Valid token, wrong email
    get edit_customer_account_activation_path(customer.activation_token, email: 'wrong')
    assert_not customer_is_logged_in?
    # Valid activation token
    get edit_customer_account_activation_path(customer.activation_token, email: customer.email)
    assert customer.reload.activated?
    follow_redirect!
    assert_template 'customers/show'
    assert customer_is_logged_in?
  end
end
