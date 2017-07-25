require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @regular_user = users(:archer)
    @non_approved_user = users(:flaky)
    @deactivated_user = users(:crusty)
    @manager_user = users(:sanchez)
    @admin_user = users(:michael)
    @other_user = users(:samson)
    @customer = customers(:university)
    @user_params = { first_name: @regular_user.first_name,
                     last_name: @regular_user.last_name,
                     gender: @regular_user.gender,
                     cell_phone: @regular_user.cell_phone,
                     email: @regular_user.email }
  end

  test 'should get index when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get users_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test 'should get index when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get users_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect index when logged in as a regular user' do
    log_in_as_regular_user
    get users_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect index when logged in as a customer' do
    log_in_as_customer
    get users_path
    assert_flash_and_login_url_redirect
  end

  test 'should get show when logged in as correct user with interpreter dashboard' do
    log_in_as_regular_user
    get user_path(@regular_user)
    assert_template :show
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test 'should get show when logged in as a manager with manager dashboard' do
    log_in_as_manager
    get user_path(@regular_user)
    assert_template :show
    assert_not_nil assigns(:user)
    assert_manager_dashboard_present_alone
  end

  test 'should get show when logged in as an admin with manager dashboard' do
    log_in_as_admin
    get user_path(@regular_user)
    assert_template :show
    assert_not_nil assigns(:user)
    assert_manager_dashboard_present_alone
  end

  test 'should redirect show when not logged in' do
    get user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect show when logged in as wrong user' do
    user_log_in_as(@other_user)
    get user_path(@regular_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect show when logged in as a customer' do
    log_in_as_customer
    get user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should get new' do
    get interpreter_signup_path
    assert_successful_application_layout
  end

  test 'should get new when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get interpreter_signup_path
    assert_template :new
    assert_not_nil assigns(:user)
    assert_manager_dashboard_present_alone
  end

  test 'should get new when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get interpreter_signup_path
    assert_template :new
    assert_not_nil assigns(:user)
    assert_manager_dashboard_present_alone
  end

  test 'should get edit when logged in as correct user' do
    log_in_as_regular_user
    get edit_user_path(@regular_user)
    assert_template :edit
    assert_not_nil assigns(:user)
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect edit when logged in as wrong user' do
    user_log_in_as(@other_user)
    get edit_user_path(@regular_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect update when not logged in' do
    patch user_path(@regular_user), params: @user_params
    assert_flash_and_login_url_redirect
  end

  test 'should redirect update when logged in as wrong user' do
    user_log_in_as(@other_user)
    patch user_path(@regular_user), params: @user_params
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@regular_user)
    end
    assert_flash_and_login_url_redirect
  end

  test 'should redirect destroy when logged in as a regular user' do
    log_in_as_regular_user
    assert_no_difference 'User.count' do
      delete user_path(@regular_user)
    end
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect destroy when logged in as a customer' do
    log_in_as_customer
    assert_no_difference 'User.count' do
      delete user_path(@regular_user)
    end
    assert_flash_and_login_url_redirect
  end

  test 'should redirect destroy when logged in as a manager' do
    log_in_as_manager
    assert_no_difference 'User.count' do
      delete user_path(@regular_user)
    end
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get pending users when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get pending_interpreters_path(@regular_user)
    assert_template :pending_users
    assert_manager_dashboard_present_alone
  end

  test 'should get pending users when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get pending_interpreters_path(@regular_user)
    assert_template :pending_users
    assert_manager_dashboard_present_alone
  end

  test 'should redirect pending users when not logged in' do
    get pending_interpreters_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect pending users when logged in as a regular user' do
    log_in_as_regular_user
    get pending_interpreters_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect pending users when logged in as a customer' do
    log_in_as_customer
    get pending_interpreters_path
    assert_flash_and_login_url_redirect
  end

  test 'should get current jobs when logged in as a regular user with interpreter dashboard' do
    log_in_as_regular_user
    get current_jobs_path(@regular_user)
    assert_template :current_jobs
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test 'should redirect current jobs when not logged in' do
    get current_jobs_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect current jobs when logged in as a deactivated user' do
    user_log_in_as(@deactivated_user)
    get current_jobs_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should get pending jobs when logged in as a regular user with interpreter dashboard' do
    log_in_as_regular_user
    get pending_jobs_path(@regular_user)
    assert_template :pending_jobs
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test 'should redirect pending jobs when not logged in' do
    get pending_jobs_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect pending jobs when logged in as a deactivated user' do
    user_log_in_as(@deactivated_user)
    get pending_jobs_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should get completed jobs when logged in as a regular user with interpreter dashboard' do
    log_in_as_regular_user
    get completed_jobs_path(@regular_user)
    assert_template :completed_jobs
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test 'should redirect completed jobs when not logged in' do
    get completed_jobs_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect completed jobs when logged in as a deactivated user' do
    user_log_in_as(@deactivated_user)
    get completed_jobs_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should get rejected jobs when logged in as a regular user with interpreter dashboard' do
    log_in_as_regular_user
    get rejected_jobs_path(@regular_user)
    assert_template :rejected_jobs
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test 'should redirect rejected jobs when not logged in' do
    get rejected_jobs_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect rejected jobs when logged in as a deactivated user' do
    user_log_in_as(@deactivated_user)
    get rejected_jobs_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should get approve account when logged in as a manager user' do
    log_in_as_manager
    get approve_account_user_path(@non_approved_user)
    assert_redirected_to pending_interpreters_url
  end

  test 'should get approve account when logged in as an admin user' do
    log_in_as_admin
    get approve_account_user_path(@non_approved_user)
    assert_redirected_to pending_interpreters_url
  end

  test 'should redirect approve account when not logged in' do
    get approve_account_user_path(@non_approved_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect approve account logged in as a regular user' do
    log_in_as_regular_user
    get approve_account_user_path(@non_approved_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect approve account when logged in as a customer' do
    log_in_as_customer
    get approve_account_user_path(@non_approved_user)
    assert_flash_and_login_url_redirect
  end

  test 'should get deactivate user when logged in as an admin user' do
    log_in_as_admin
    get deactivate_user_user_path(@non_approved_user)
    assert_redirected_to user_path(@non_approved_user)
  end

  test 'should redirect deactivate user when not logged in' do
    get deactivate_user_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect deactivate user when logged in as a regular user' do
    log_in_as_regular_user
    get deactivate_user_user_path(@regular_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect deactivate user when logged in as a customer' do
    log_in_as_customer
    get deactivate_user_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect deactivate user when logged in as a manager' do
    log_in_as_manager
    get deactivate_user_user_path(@regular_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get reactivate user when logged in as an admin user' do
    log_in_as_admin
    get reactivate_user_user_path(@deactivated_user)
    assert_redirected_to user_path(@deactivated_user)
  end

  test 'should redirect reactivate user when not logged in' do
    get reactivate_user_user_path(@deactivated_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect reactivate user when logged in as a regular user' do
    log_in_as_regular_user
    get reactivate_user_user_path(@deactivated_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect reactivate user when logged in as a customer' do
    log_in_as_customer
    get reactivate_user_user_path(@deactivated_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect reactivate user when logged in as a manager' do
    log_in_as_manager
    get reactivate_user_user_path(@deactivated_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get promote to manager when logged in as an admin user' do
    log_in_as_admin
    get promote_to_manager_user_path(@other_user)
    assert_redirected_to user_path(@other_user)
  end

  test 'should redirect promote to manager when not logged in' do
    get promote_to_manager_user_path(@other_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect promote to manager when logged in as a regular user' do
    log_in_as_regular_user
    get promote_to_manager_user_path(@other_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect promote to manager when logged in as a customer' do
    log_in_as_customer
    get promote_to_manager_user_path(@other_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect promote to manager when logged in as a manager' do
    log_in_as_manager
    get promote_to_manager_user_path(@other_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get promote to admin when logged in as an admin user' do
    log_in_as_admin
    get promote_to_admin_user_path(@manager_user)
    assert_redirected_to user_path(@manager_user)
  end

  test 'should redirect promote to admin when not logged in' do
    get promote_to_admin_user_path(@manager_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect promote to admin when logged in as a regular user' do
    log_in_as_regular_user
    get promote_to_admin_user_path(@manager_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect promote to admin when logged in as a customer' do
    log_in_as_customer
    get promote_to_admin_user_path(@manager_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect promote to admin when logged in as a manager' do
    log_in_as_manager
    get promote_to_admin_user_path(@manager_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get demote to manager when logged in as an admin user' do
    log_in_as_admin
    get demote_to_manager_user_path(@admin_user)
    assert_redirected_to user_path(@admin_user)
  end

  test 'should redirect demote to manager when not logged in' do
    get demote_to_manager_user_path(@admin_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect demote to manager when logged in as a regular user' do
    log_in_as_regular_user
    get demote_to_manager_user_path(@admin_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect demote to manager when logged in as a customer' do
    log_in_as_customer
    get demote_to_manager_user_path(@admin_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect demote to manager when logged in as a manager' do
    log_in_as_manager
    get demote_to_manager_user_path(@admin_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get demote to interpreter when logged in as an admin user' do
    log_in_as_admin
    get demote_to_interpreter_user_path(@manager_user)
    assert_redirected_to user_path(@manager_user)
  end

  test 'should redirect demote to interpreter when not logged in' do
    get demote_to_interpreter_user_path(@manager_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect demote to interpreter when logged in as a regular user' do
    log_in_as_regular_user
    get demote_to_interpreter_user_path(@manager_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect demote to interpreter when logged in as a customer' do
    log_in_as_customer
    get demote_to_interpreter_user_path(@manager_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect demote to interpreter when logged in as a manager' do
    log_in_as_manager
    get demote_to_interpreter_user_path(@manager_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get promote qualification when logged in as a manager user' do
    log_in_as_manager
    get promote_qualification_user_path(@regular_user)
    assert_redirected_to user_path(@regular_user)
  end

  test 'should get promote qualification when logged in as an admin user' do
    log_in_as_admin
    get promote_qualification_user_path(@regular_user)
    assert_redirected_to user_path(@regular_user)
  end

  test 'should redirect promote qualification when not logged in' do
    get promote_qualification_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect promote qualification logged in as a regular user' do
    log_in_as_regular_user
    get promote_qualification_user_path(@regular_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect promote qualification when logged in as a customer' do
    log_in_as_customer
    get promote_qualification_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should get revoke qualification when logged in as a manager user' do
    log_in_as_manager
    get revoke_qualification_user_path(@regular_user)
    assert_redirected_to user_path(@regular_user)
  end

  test 'should get revoke qualification when logged in as an admin user' do
    log_in_as_admin
    get revoke_qualification_user_path(@regular_user)
    assert_redirected_to user_path(@regular_user)
  end

  test 'should redirect revoke qualification when not logged in' do
    get revoke_qualification_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect revoke qualification logged in as a regular user' do
    log_in_as_regular_user
    get revoke_qualification_user_path(@regular_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect revoke qualification when logged in as a customer' do
    log_in_as_customer
    get revoke_qualification_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  # test 'should get approve job request when logged in as a manager user' do
  #   log_in_as_manager
  #   get approve_job_request_user_path(@regular_user)
  #   assert_redirected_to user_path(@regular_user)
  # end

  # test 'should get approve job request when logged in as an admin user' do
  #   log_in_as_admin
  #   get approve_job_request_user_path(@regular_user)
  #   assert_redirected_to user_path(@regular_user)
  # end

  test 'should redirect approve job request when not logged in' do
    get approve_job_request_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect approve job request logged in as a regular user' do
    log_in_as_regular_user
    get approve_job_request_user_path(@regular_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect approve job request when logged in as a customer' do
    log_in_as_customer
    get approve_job_request_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  # test 'should get reject job request when logged in as a manager user' do
  #   log_in_as_manager
  #   get reject_job_request_user_path(@regular_user)
  #   assert_redirected_to user_path(@regular_user)
  # end

  # test 'should get reject job request when logged in as an admin user' do
  #   log_in_as_admin
  #   get reject_job_request_user_path(@regular_user)
  #   assert_redirected_to user_path(@regular_user)
  # end

  test 'should redirect reject job request when not logged in' do
    get reject_job_request_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect reject job request logged in as a regular user' do
    log_in_as_regular_user
    get reject_job_request_user_path(@regular_user)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect reject job request when logged in as a customer' do
    log_in_as_customer
    get reject_job_request_user_path(@regular_user)
    assert_flash_and_login_url_redirect
  end
end
