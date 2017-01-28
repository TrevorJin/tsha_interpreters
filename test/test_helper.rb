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

  def assert_manager_dashboard_present_alone
    assert_manager_dashboard_present
    assert_customer_dashboard_not_present
  end

  def assert_customer_dashboard_present_alone
    assert_customer_dashboard_present
    assert_manager_dashboard_not_present
  end

  def assert_interpreter_dashboard_present_alone
    assert_interpreter_dashboard_present
    assert_manager_dashboard_not_present
    assert_customer_dashboard_not_present
  end

  def assert_manager_dashboard_present
    assert_not_nil assigns(:pending_users)
    assert_not_nil assigns(:total_users)
    assert_not_nil assigns(:total_customers)
    assert_not_nil assigns(:pending_customers)
    assert_not_nil assigns(:job_requests_awaiting_approval)
    assert_not_nil assigns(:job_requests_not_awaiting_approval)
    assert_not_nil assigns(:job_requests)
    assert_not_nil assigns(:jobs_in_need_of_confirmation)
    assert_not_nil assigns(:jobs_with_interpreter_assigned)
    assert_not_nil assigns(:confirmed_jobs)
    assert_not_nil assigns(:jobs_awaiting_completion)
    assert_not_nil assigns(:jobs_awaiting_invoice)
    assert_not_nil assigns(:processed_jobs)
    assert_not_nil assigns(:expired_jobs)
    assert_not_nil assigns(:total_jobs)
    assert_not_nil assigns(:interpreter_invoices)
    assert_not_nil assigns(:manager_invoices)
  end

  def assert_manager_dashboard_not_present
    assert_nil assigns(:pending_users)
    assert_nil assigns(:total_users)
    assert_nil assigns(:total_customers)
    assert_nil assigns(:pending_customers)
    assert_nil assigns(:job_requests_awaiting_approval)
    assert_nil assigns(:job_requests_not_awaiting_approval)
    assert_nil assigns(:job_requests)
    assert_nil assigns(:jobs_in_need_of_confirmation)
    assert_nil assigns(:jobs_with_interpreter_assigned)
    assert_nil assigns(:confirmed_jobs)
    assert_nil assigns(:jobs_awaiting_completion)
    assert_nil assigns(:jobs_awaiting_invoice)
    assert_nil assigns(:processed_jobs)
    assert_nil assigns(:expired_jobs)
    assert_nil assigns(:total_jobs)
  end

  def assert_customer_dashboard_present
    assert_not_nil assigns(:pending_job_requests)
    assert_not_nil assigns(:approved_job_requests)
    assert_not_nil assigns(:rejected_job_requests)
    assert_not_nil assigns(:expired_job_requests)
    assert_not_nil assigns(:total_job_requests)
    assert_not_nil assigns(:current_jobs)
    assert_not_nil assigns(:completed_jobs)
    assert_not_nil assigns(:customer_jobs)
    assert_not_nil assigns(:pending_jobs)
    assert_not_nil assigns(:manager_invoices)
  end

  def assert_customer_dashboard_not_present
    assert_nil assigns(:pending_job_requests)
    assert_nil assigns(:approved_job_requests)
    assert_nil assigns(:rejected_job_requests)
    assert_nil assigns(:expired_job_requests)
    assert_nil assigns(:total_job_requests)
    assert_nil assigns(:customer_jobs)
  end

  def assert_interpreter_dashboard_present
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:user_jobs)
    assert_not_nil assigns(:current_jobs)
    assert_not_nil assigns(:pending_jobs)
    assert_not_nil assigns(:completed_jobs)
    assert_not_nil assigns(:rejected_jobs)
    assert_not_nil assigns(:interpreter_invoices)
    assert_not_nil assigns(:manager_invoices)
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
