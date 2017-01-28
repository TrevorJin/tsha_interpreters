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
  end

  test "should get index when logged in as a manager user with manager dashboard" do
    user_log_in_as(@manager_user)
    get users_path
    assert_response :success
    assert_template :index
    assert_template layout: "layouts/application"
    assert_manager_dashboard_present_alone
  end

  test "should get index when logged in as an admin user with manager dashboard" do
    user_log_in_as(@admin_user)
    get users_path
    assert_response :success
    assert_template :index
    assert_template layout: "layouts/application"
    assert_manager_dashboard_present_alone
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect index when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get users_path
    assert_redirected_to root_url
  end

  test "should redirect index when logged in as a customer" do
    customer_log_in_as(@customer)
    get users_path
    assert_redirected_to login_url
  end

  test "should get show when logged in as correct user with interpreter dashboard" do
    user_log_in_as(@regular_user)
    get user_path(@regular_user)
    assert_response :success
    assert_template :show
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test "should get show when logged in as a manager with manager dashboard" do
    user_log_in_as(@manager_user)
    get user_path(@regular_user)
    assert_response :success
    assert_template :show
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_manager_dashboard_present_alone
  end

  test "should get show when logged in as an admin with manager dashboard" do
    user_log_in_as(@admin_user)
    get user_path(@regular_user)
    assert_response :success
    assert_template :show
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_manager_dashboard_present_alone
  end

  test "should redirect show when not logged in" do
    get user_path(@regular_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect show when logged in as wrong user" do
    user_log_in_as(@other_user)
    get user_path(@regular_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect show when logged in as a customer" do
    customer_log_in_as(@customer)
    get user_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should get new" do
    get interpreter_signup_path
    assert_response :success
  end

  test "should get new when logged in as a manager user with manager dashboard" do
    user_log_in_as(@manager_user)
    get interpreter_signup_path
    assert_response :success
    assert_template :new
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_manager_dashboard_present_alone
  end

  test "should get new when logged in as an admin user with manager dashboard" do
    user_log_in_as(@admin_user)
    get interpreter_signup_path
    assert_response :success
    assert_template :new
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_manager_dashboard_present_alone
  end

  test "should get edit when logged in as correct user" do
    user_log_in_as(@regular_user)
    get edit_user_path(@regular_user)
    assert_response :success
    assert_template :edit
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@regular_user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    user_log_in_as(@other_user)
    get edit_user_path(@regular_user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@regular_user), params: { first_name: @regular_user.first_name, last_name: @regular_user.last_name,
                                              gender: @regular_user.gender, cell_phone: @regular_user.cell_phone,
                                              email: @regular_user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong user" do
    user_log_in_as(@other_user)
    patch user_path(@regular_user), params: { first_name: @regular_user.first_name, last_name: @regular_user.last_name,
                                              gender: @regular_user.gender, cell_phone: @regular_user.cell_phone,
                                              email: @regular_user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@regular_user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a regular user" do
    user_log_in_as(@regular_user)
    assert_no_difference 'User.count' do
      delete user_path(@regular_user)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a customer" do
    customer_log_in_as(@customer)
    assert_no_difference 'User.count' do
      delete user_path(@regular_user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a manager" do
    user_log_in_as(@manager_user)
    assert_no_difference 'User.count' do
      delete user_path(@regular_user)
    end
    assert_redirected_to root_url
  end

  test "should get pending users when logged in as a manager user with manager dashboard" do
    user_log_in_as(@manager_user)
    get pending_interpreters_path(@regular_user)
    assert_response :success
    assert_template :pending_users
    assert_template layout: "layouts/application"
    assert_manager_dashboard_present_alone
  end

  test "should get pending users when logged in as an admin user with manager dashboard" do
    user_log_in_as(@admin_user)
    get pending_interpreters_path(@regular_user)
    assert_response :success
    assert_template :pending_users
    assert_template layout: "layouts/application"
    assert_manager_dashboard_present_alone
  end

  test "should redirect pending users when not logged in" do
    get pending_interpreters_path
    assert_redirected_to login_url
  end

  test "should redirect pending users when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get pending_interpreters_path
    assert_redirected_to root_url
  end

  test "should redirect pending users when logged in as a customer" do
    customer_log_in_as(@customer)
    get pending_interpreters_path
    assert_redirected_to login_url
  end

  test "should get current jobs when logged in as a regular user with interpreter dashboard" do
    user_log_in_as(@regular_user)
    get current_jobs_path(@regular_user)
    assert_response :success
    assert_template :current_jobs
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test "should redirect current jobs when not logged in" do
    get current_jobs_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect current jobs when logged in as a deactivated user" do
    user_log_in_as(@deactivated_user)
    get current_jobs_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should get pending jobs when logged in as a regular user with interpreter dashboard" do
    user_log_in_as(@regular_user)
    get pending_jobs_path(@regular_user)
    assert_response :success
    assert_template :pending_jobs
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test "should redirect pending jobs when not logged in" do
    get pending_jobs_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect pending jobs when logged in as a deactivated user" do
    user_log_in_as(@deactivated_user)
    get pending_jobs_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should get completed jobs when logged in as a regular user with interpreter dashboard" do
    user_log_in_as(@regular_user)
    get completed_jobs_path(@regular_user)
    assert_response :success
    assert_template :completed_jobs
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test "should redirect completed jobs when not logged in" do
    get completed_jobs_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect completed jobs when logged in as a deactivated user" do
    user_log_in_as(@deactivated_user)
    get completed_jobs_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should get rejected jobs when logged in as a regular user with interpreter dashboard" do
    user_log_in_as(@regular_user)
    get rejected_jobs_path(@regular_user)
    assert_response :success
    assert_template :rejected_jobs
    assert_template layout: "layouts/application"
    assert_not_nil assigns(:user)
    assert_interpreter_dashboard_present_alone
  end

  test "should redirect rejected jobs when not logged in" do
    get rejected_jobs_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect rejected jobs when logged in as a deactivated user" do
    user_log_in_as(@deactivated_user)
    get rejected_jobs_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should get approve account when logged in as a manager user" do
    user_log_in_as(@manager_user)
    get approve_account_user_path(@non_approved_user)
    assert_redirected_to pending_interpreters_url
  end

  test "should get approve account when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get approve_account_user_path(@non_approved_user)
    assert_redirected_to pending_interpreters_url
  end

  test "should redirect approve account when not logged in" do
    get approve_account_user_path(@non_approved_user)
    assert_redirected_to login_url
  end

  test "should redirect approve account logged in as a regular user" do
    user_log_in_as(@regular_user)
    get approve_account_user_path(@non_approved_user)
    assert_redirected_to root_url
  end

  test "should redirect approve account when logged in as a customer" do
    customer_log_in_as(@customer)
    get approve_account_user_path(@non_approved_user)
    assert_redirected_to login_url
  end

  test "should get deactivate user when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get deactivate_user_user_path(@non_approved_user)
    assert_redirected_to user_path(@non_approved_user)
  end

  test "should redirect deactivate user when not logged in" do
    get deactivate_user_user_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect deactivate user when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get deactivate_user_user_path(@regular_user)
    assert_redirected_to root_url
  end

  test "should redirect deactivate user when logged in as a customer" do
    customer_log_in_as(@customer)
    get deactivate_user_user_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect deactivate user when logged in as a manager" do
    user_log_in_as(@manager_user)
    get deactivate_user_user_path(@regular_user)
    assert_redirected_to root_url
  end

  test "should get reactivate user when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get reactivate_user_user_path(@deactivated_user)
    assert_redirected_to user_path(@deactivated_user)
  end

  test "should redirect reactivate user when not logged in" do
    get reactivate_user_user_path(@deactivated_user)
    assert_redirected_to login_url
  end

  test "should redirect reactivate user when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get reactivate_user_user_path(@deactivated_user)
    assert_redirected_to root_url
  end

  test "should redirect reactivate user when logged in as a customer" do
    customer_log_in_as(@customer)
    get reactivate_user_user_path(@deactivated_user)
    assert_redirected_to login_url
  end

  test "should redirect reactivate user when logged in as a manager" do
    user_log_in_as(@manager_user)
    get reactivate_user_user_path(@deactivated_user)
    assert_redirected_to root_url
  end

  test "should get promote to manager when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get promote_to_manager_user_path(@other_user)
    assert_redirected_to user_path(@other_user)
  end

  test "should redirect promote to manager when not logged in" do
    get promote_to_manager_user_path(@other_user)
    assert_redirected_to login_url
  end

  test "should redirect promote to manager when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get promote_to_manager_user_path(@other_user)
    assert_redirected_to root_url
  end

  test "should redirect promote to manager when logged in as a customer" do
    customer_log_in_as(@customer)
    get promote_to_manager_user_path(@other_user)
    assert_redirected_to login_url
  end

  test "should redirect promote to manager when logged in as a manager" do
    user_log_in_as(@manager_user)
    get promote_to_manager_user_path(@other_user)
    assert_redirected_to root_url
  end

  test "should get promote to admin when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get promote_to_admin_user_path(@manager_user)
    assert_redirected_to user_path(@manager_user)
  end

  test "should redirect promote to admin when not logged in" do
    get promote_to_admin_user_path(@manager_user)
    assert_redirected_to login_url
  end

  test "should redirect promote to admin when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get promote_to_admin_user_path(@manager_user)
    assert_redirected_to root_url
  end

  test "should redirect promote to admin when logged in as a customer" do
    customer_log_in_as(@customer)
    get promote_to_admin_user_path(@manager_user)
    assert_redirected_to login_url
  end

  test "should redirect promote to admin when logged in as a manager" do
    user_log_in_as(@manager_user)
    get promote_to_admin_user_path(@manager_user)
    assert_redirected_to root_url
  end

  test "should get demote to manager when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get demote_to_manager_user_path(@admin_user)
    assert_redirected_to user_path(@admin_user)
  end

  test "should redirect demote to manager when not logged in" do
    get demote_to_manager_user_path(@admin_user)
    assert_redirected_to login_url
  end

  test "should redirect demote to manager when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get demote_to_manager_user_path(@admin_user)
    assert_redirected_to root_url
  end

  test "should redirect demote to manager when logged in as a customer" do
    customer_log_in_as(@customer)
    get demote_to_manager_user_path(@admin_user)
    assert_redirected_to login_url
  end

  test "should redirect demote to manager when logged in as a manager" do
    user_log_in_as(@manager_user)
    get demote_to_manager_user_path(@admin_user)
    assert_redirected_to root_url
  end

  test "should get demote to interpreter when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get demote_to_manager_user_path(@manager_user)
    assert_redirected_to user_path(@manager_user)
  end

  test "should redirect demote to interpreter when not logged in" do
    get demote_to_manager_user_path(@manager_user)
    assert_redirected_to login_url
  end

  test "should redirect demote to interpreter when logged in as a regular user" do
    user_log_in_as(@regular_user)
    get demote_to_manager_user_path(@manager_user)
    assert_redirected_to root_url
  end

  test "should redirect demote to interpreter when logged in as a customer" do
    customer_log_in_as(@customer)
    get demote_to_manager_user_path(@manager_user)
    assert_redirected_to login_url
  end

  test "should redirect demote to interpreter when logged in as a manager" do
    user_log_in_as(@manager_user)
    get demote_to_manager_user_path(@manager_user)
    assert_redirected_to root_url
  end

  test "should get promote qualification when logged in as a manager user" do
    user_log_in_as(@manager_user)
    get promote_qualification_user_path(@regular_user)
    assert_redirected_to user_path(@regular_user)
  end

  test "should get promote qualification when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get promote_qualification_user_path(@regular_user)
    assert_redirected_to user_path(@regular_user)
  end

  test "should redirect promote qualification when not logged in" do
    get promote_qualification_user_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect promote qualification logged in as a regular user" do
    user_log_in_as(@regular_user)
    get promote_qualification_user_path(@regular_user)
    assert_redirected_to root_url
  end

  test "should redirect promote qualification when logged in as a customer" do
    customer_log_in_as(@customer)
    get promote_qualification_user_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should get revoke qualification when logged in as a manager user" do
    user_log_in_as(@manager_user)
    get revoke_qualification_user_path(@regular_user)
    assert_redirected_to user_path(@regular_user)
  end

  test "should get revoke qualification when logged in as an admin user" do
    user_log_in_as(@admin_user)
    get revoke_qualification_user_path(@regular_user)
    assert_redirected_to user_path(@regular_user)
  end

  test "should redirect revoke qualification when not logged in" do
    get revoke_qualification_user_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect revoke qualification logged in as a regular user" do
    user_log_in_as(@regular_user)
    get revoke_qualification_user_path(@regular_user)
    assert_redirected_to root_url
  end

  test "should redirect revoke qualification when logged in as a customer" do
    customer_log_in_as(@customer)
    get revoke_qualification_user_path(@regular_user)
    assert_redirected_to login_url
  end

  # test "should get approve job request when logged in as a manager user" do
  #   user_log_in_as(@manager_user)
  #   get approve_job_request_user_path(@regular_user)
  #   assert_redirected_to user_path(@regular_user)
  # end

  # test "should get approve job request when logged in as an admin user" do
  #   user_log_in_as(@admin_user)
  #   get approve_job_request_user_path(@regular_user)
  #   assert_redirected_to user_path(@regular_user)
  # end

  test "should redirect approve job request when not logged in" do
    get approve_job_request_user_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect approve job request logged in as a regular user" do
    user_log_in_as(@regular_user)
    get approve_job_request_user_path(@regular_user)
    assert_redirected_to root_url
  end

  test "should redirect approve job request when logged in as a customer" do
    customer_log_in_as(@customer)
    get approve_job_request_user_path(@regular_user)
    assert_redirected_to login_url
  end

  # test "should get reject job request when logged in as a manager user" do
  #   user_log_in_as(@manager_user)
  #   get reject_job_request_user_path(@regular_user)
  #   assert_redirected_to user_path(@regular_user)
  # end

  # test "should get reject job request when logged in as an admin user" do
  #   user_log_in_as(@admin_user)
  #   get reject_job_request_user_path(@regular_user)
  #   assert_redirected_to user_path(@regular_user)
  # end

  test "should redirect reject job request when not logged in" do
    get reject_job_request_user_path(@regular_user)
    assert_redirected_to login_url
  end

  test "should redirect reject job request logged in as a regular user" do
    user_log_in_as(@regular_user)
    get reject_job_request_user_path(@regular_user)
    assert_redirected_to root_url
  end

  test "should redirect reject job request when logged in as a customer" do
    customer_log_in_as(@customer)
    get reject_job_request_user_path(@regular_user)
    assert_redirected_to login_url
  end
end
