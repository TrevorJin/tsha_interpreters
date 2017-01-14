ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # User Helpers

  # Returns true if a test user is logged in.
  def user_is_logged_in?
    !session[:user_id].nil?
  end

  # Logs in as a particular user.
  def user_log_in_as(user)
    session[:user_id] = user.id
  end

  # Customer Helpers

  # Returns true if a test customer is logged in.
  def customer_is_logged_in?
    !session[:customer_id].nil?
  end

  # Logs in as a particular customer.
  def customer_log_in_as(customer)
    session[:customer_id] = customer.id
  end
end

class ActionDispatch::IntegrationTest

  # Logs in as a particular user.
  def user_log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end

  # Logs in as a particular customer.
  def customer_log_in_as(customer, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: customer.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
