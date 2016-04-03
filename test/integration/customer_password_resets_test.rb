require 'test_helper'

class CustomerPasswordResetsTest < ActionDispatch::IntegrationTest

  # def setup
  #   ActionMailer::Base.deliveries.clear
  #   @customer = customers(:university)
  # end

  # test "customer password resets" do
  #   get new_customer_password_reset_path
  #   assert_template 'customer_password_resets/new'
  #   # Invalid email
  #   post customer_password_resets_path, customer_password_reset: { email: "" }
  #   assert_not flash.empty?
  #   assert_template 'customer_password_resets/new'
  #   # Valid email
  #   post customer_password_resets_path, customer_password_reset: { email: @customer.email }
  #   assert_not_equal @customer.reset_digest, @customer.reload.reset_digest
  #   assert_equal 1, ActionMailer::Base.deliveries.size
  #   assert_not flash.empty?
  #   assert_redirected_to root_url
  #   # Password reset form
  #   customer = assigns(:customer)
  #   # Wrong email
  #   get edit_customer_password_reset_path(customer.reset_token, email: "")
  #   assert_redirected_to root_url
  #   # Inactive customer
  #   customer.toggle!(:activated)
  #   get edit_customer_password_reset_path(customer.reset_token, email: customer.email)
  #   assert_redirected_to root_url
  #   customer.toggle!(:activated)
  #   # Right email, wrong token
  #   get edit_customer_password_reset_path('wrong token', email: customer.email)
  #   assert_redirected_to root_url
  #   # Right email, right token
  #   get edit_customer_password_reset_path(customer.reset_token, email: customer.email)
  #   assert_template 'customer_password_resets/edit'
  #   assert_select "input[name=email][type=hidden][value=?]", customer.email
  #   # Invalid password & confirmation
  #   patch customer_password_reset_path(customer.reset_token),
  #         email: customer.email,
  #         customer: { password:              "foobaz",
  #                     password_confirmation: "barquux" }
  #   assert_select 'div#error_explanation'
  #   # Empty password
  #   patch customer_password_reset_path(customer.reset_token),
  #         email: customer.email,
  #         customer: { password:              "",
  #                     password_confirmation: "" }
  #   assert_select 'div#error_explanation'
  #   # Valid password & confirmation
  #   patch customer_password_reset_path(customer.reset_token),
  #         email: customer.email,
  #         customer: { password:              "foobaz",
  #                     password_confirmation: "foobaz" }
  #   assert customer_is_logged_in?
  #   assert_not flash.empty?
  #   assert_redirected_to customer
  # end
end
