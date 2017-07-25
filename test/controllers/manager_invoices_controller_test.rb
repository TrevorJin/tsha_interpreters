require 'test_helper'

class ManagerInvoicesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @non_active_user = users(:will)
    @non_active_customer = customers(:apple)
    @manager_invoice = manager_invoices(:one)
  end

  test 'should get index when logged in as a customer with customer dashboard' do
    log_in_as_customer
    get manager_invoices_path
    assert_template :index
    assert_customer_dashboard_present_alone
  end

  test 'should get index when logged in as a regular user with interpreter dashboard' do
    log_in_as_regular_user
    get manager_invoices_path
    assert_template :index
    assert_interpreter_dashboard_present_alone
  end

  test 'should get index when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get manager_invoices_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test 'should get index when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get manager_invoices_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test 'should redirect index when not logged in' do
    get manager_invoices_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect index when logged in as a non active user' do
    user_log_in_as(@non_active_user)
    get manager_invoices_path
    assert flash.empty?
    assert_redirected_to jobs_url
  end

  test 'should redirect index when logged in as a non active customer' do
    customer_log_in_as(@non_active_customer)
    get manager_invoices_path
    assert flash.empty?
    assert_redirected_to jobs_url
  end

  test 'should get show when logged in as a customer with customer dashboard' do
    log_in_as_customer
    get manager_invoice_path(@manager_invoice)
    assert_template :show
    assert_customer_dashboard_present_alone
  end

  test 'should get show when logged in as a regular user with interpreter dashboard' do
    log_in_as_regular_user
    get manager_invoice_path(@manager_invoice)
    assert_template :show
    assert_interpreter_dashboard_present_alone
  end

  test 'should get show when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get manager_invoice_path(@manager_invoice)
    assert_template :show
    assert_manager_dashboard_present_alone
  end

  test 'should get show when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get manager_invoice_path(@manager_invoice)
    assert_template :show
    assert_manager_dashboard_present_alone
  end

  test 'should redirect show when not logged in' do
    get manager_invoice_path(@manager_invoice)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect show when logged in as a non active user' do
    user_log_in_as(@non_active_user)
    get manager_invoice_path(@manager_invoice)
    assert flash.empty?
    assert_redirected_to jobs_url
  end

  test 'should redirect show when logged in as a non active customer' do
    customer_log_in_as(@non_active_customer)
    get manager_invoice_path(@manager_invoice)
    assert flash.empty?
    assert_redirected_to jobs_url
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'ManagerInvoice.count' do
      post manager_invoices_path
    end
    assert_flash_and_login_url_redirect
  end

  test 'should redirect create when logged in as a non active user' do
    user_log_in_as(@non_active_user)
    assert_no_difference 'ManagerInvoice.count' do
      post manager_invoices_path
    end
    assert_empty_flash_and_root_url_redirect
  end
end
