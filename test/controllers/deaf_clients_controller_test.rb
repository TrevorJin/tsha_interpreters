require 'test_helper'

class DeafClientsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @deaf_client = deaf_clients(:sally)
    @deaf_client_params = { first_name: @deaf_client.first_name,
                            last_name: @deaf_client.last_name,
                            internal_notes: @deaf_client.internal_notes,
                            public_notes: @deaf_client.public_notes }
  end

  test 'should get index when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get deaf_clients_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test 'should get index when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get deaf_clients_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test 'should redirect index when not logged in' do
    get deaf_clients_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect index when logged in as a regular user' do
    log_in_as_regular_user
    get deaf_clients_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect index when logged in as a customer' do
    log_in_as_customer
    get deaf_clients_path
    assert_flash_and_login_url_redirect
  end

  test 'should get show when logged in as a manager with manager dashboard' do
    log_in_as_manager
    get deaf_client_path(@deaf_client)
    assert_template :show
    assert_not_nil assigns(:deaf_client)
    assert_manager_dashboard_present_alone
  end

  test 'should get show when logged in as an admin with manager dashboard' do
    log_in_as_admin
    get deaf_client_path(@deaf_client)
    assert_template :show
    assert_not_nil assigns(:deaf_client)
    assert_manager_dashboard_present_alone
  end

  test 'should redirect show when not logged in' do
    get deaf_client_path(@deaf_client)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect show when logged in as a regular user' do
    log_in_as_regular_user
    get deaf_client_path(@deaf_client)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get new when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get new_deaf_client_path
    assert_template :new
    assert_not_nil assigns(:deaf_client)
    assert_manager_dashboard_present_alone
  end

  test 'should get new when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get new_deaf_client_path
    assert_template :new
    assert_not_nil assigns(:deaf_client)
    assert_manager_dashboard_present_alone
  end

  test 'should redirect new when not logged in' do
    get new_deaf_client_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect new when logged in as a regular user' do
    log_in_as_regular_user
    get new_deaf_client_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect new when logged in as a customer' do
    log_in_as_customer
    get new_deaf_client_path
    assert_flash_and_login_url_redirect
  end

  test 'should get edit when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get edit_deaf_client_path(@deaf_client)
    assert_template :edit
    assert_not_nil assigns(:deaf_client)
    assert_manager_dashboard_present_alone
  end

  test 'should get edit when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get edit_deaf_client_path(@deaf_client)
    assert_template :edit
    assert_not_nil assigns(:deaf_client)
    assert_manager_dashboard_present_alone
  end

  test 'should redirect edit when not logged in' do
    get edit_deaf_client_path(@deaf_client)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect edit when logged in as a regular user' do
    log_in_as_regular_user
    get edit_deaf_client_path(@deaf_client)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect edit when logged in as a customer' do
    log_in_as_customer
    get edit_deaf_client_path(@deaf_client)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect update when not logged in' do
    patch deaf_client_path(@deaf_client), params: @deaf_client_params
    assert_flash_and_login_url_redirect
  end

  test 'should redirect update when logged in as a regular user' do
    log_in_as_regular_user
    patch deaf_client_path(@deaf_client), params: @deaf_client_params
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect update when logged in as a customer' do
    log_in_as_customer
    patch deaf_client_path(@deaf_client), params: @deaf_client_params
    assert_flash_and_login_url_redirect
  end
end
