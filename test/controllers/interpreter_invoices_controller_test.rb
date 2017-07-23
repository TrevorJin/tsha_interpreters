require 'test_helper'

class InterpreterInvoicesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @non_active_user = users(:will)
    @interpreter_invoice = interpreter_invoices(:one)
  end

  test "should get index when logged in as an activated regular user with interpreter dashboard" do
    log_in_as_regular_user
    get interpreter_invoices_path
    assert_template :index
    assert_interpreter_dashboard_present_alone
  end

  test "should get index when logged in as a manager user with manager dashboard" do
    log_in_as_manager
    get interpreter_invoices_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test "should get index when logged in as an admin user with manager dashboard" do
    log_in_as_admin
    get interpreter_invoices_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test "should redirect index when not logged in" do
    get interpreter_invoices_path
    assert_flash_and_login_url_redirect
  end

  test "should redirect index when logged in as a non active user" do
    user_log_in_as(@non_active_user)
    get interpreter_invoices_path
    assert flash.empty?
    assert_redirected_to jobs_url
  end

  test "should redirect index when logged in as a customer" do
    log_in_as_customer
    get interpreter_invoices_path
    assert_flash_and_login_url_redirect
  end

  test "should get show when logged in as an activated regular user with interpreter dashboard" do
    log_in_as_regular_user
    get interpreter_invoice_path(@interpreter_invoice)
    assert_template :show
    assert_interpreter_dashboard_present_alone
  end

  test "should get show when logged in as a manager user with manager dashboard" do
    log_in_as_manager
    get interpreter_invoice_path(@interpreter_invoice)
    assert_template :show
    assert_manager_dashboard_present_alone
  end

  test "should get show when logged in as an admin user with manager dashboard" do
    log_in_as_admin
    get interpreter_invoice_path(@interpreter_invoice)
    assert_template :show
    assert_manager_dashboard_present_alone
  end

  test "should redirect show when not logged in" do
    get interpreter_invoice_path(@interpreter_invoice)
    assert_flash_and_login_url_redirect
  end

  test "should redirect show when logged in as a non active user" do
    user_log_in_as(@non_active_user)
    get interpreter_invoice_path(@interpreter_invoice)
    assert flash.empty?
    assert_redirected_to jobs_url
  end

  test "should redirect show when logged in as a customer" do
    log_in_as_customer
    get interpreter_invoice_path(@interpreter_invoice)
    assert_flash_and_login_url_redirect
  end
end
