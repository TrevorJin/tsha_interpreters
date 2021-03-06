require 'test_helper'

class JobsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @job = jobs(:one)
    @correct_customer = customers(:university)
    @incorrect_customer = customers(:hideaway)
    @correct_user = users(:wonka)
    @incorrect_user = users(:archer)
    @job_request = job_requests(:one)
    @job_params = { requester_first_name: @correct_user.first_name,
                    requester_last_name: @correct_user.last_name }
  end

  test 'should get index when logged in as a regular user' do
    log_in_as_regular_user
    get jobs_path
    assert_interpreter_dashboard_present_alone
  end
  
  test 'should get index when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get jobs_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test 'should get index when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get jobs_path
    assert_template :index
    assert_manager_dashboard_present_alone
  end

  test 'should redirect index when not logged in' do
    get jobs_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect index when logged in as a customer' do
    log_in_as_customer
    get jobs_path
    assert_flash_and_login_url_redirect
  end

  test 'should get show when logged in as correct customer with customer dashboard' do
    customer_log_in_as(@correct_customer)
    get job_path(@job)
    assert_template :show
    assert_customer_dashboard_present_alone
  end

  test 'should get show when logged in as correct user with interpreter dashboard' do
    user_log_in_as(@correct_user)
    get job_path(@job)
    assert_template :show
    assert_interpreter_dashboard_present_alone
  end

  test 'should get show when logged in as a manger user with manager dashboard' do
    log_in_as_manager
    get job_path(@job)
    assert_template :show
    assert_manager_dashboard_present_alone
  end

  test 'should get show when logged in as an admin user with manager dashboard' do
    log_in_as_manager
    get job_path(@job)
    assert_template :show
    assert_manager_dashboard_present_alone
  end

  test 'should redirect show when not logged in' do
    get job_path(@job)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect show when logged in as incorrect user' do
    user_log_in_as(@incorrect_user)
    get job_path(@job)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect show when logged in as incorrect customer' do
    customer_log_in_as(@incorrect_customer)
    get job_path(@job)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should get new when logged in as a manger user with manager dashboard' do
    log_in_as_manager
    get new_job_path
    assert_template :new
    assert_manager_dashboard_present_alone
  end

  test 'should get new when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get new_job_path
    assert_template :new
    assert_manager_dashboard_present_alone
  end

  test 'should redirect new when not logged in' do
    get new_job_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect new when logged in as a regular user' do
    log_in_as_regular_user
    get new_job_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect new when logged in as a customer' do
    log_in_as_customer
    get new_job_path
    assert_flash_and_login_url_redirect
  end
  
  # Needs proper job request factory
  # test 'should get new job from job request when logged in as a manger user with manager dashboard' do
  #   log_in_as_manager
  #   get new_job_from_job_request_job_path(@job_request)
  #   assert_manager_dashboard_present_alone
  # end

  # test 'should get new job from job request when logged in as an admin user with manager dashboard' do
  #   log_in_as_admin
  #   get new_job_from_job_request_job_path(@job_request)
  #   assert_manager_dashboard_present_alone
  # end

  test 'should redirect new job from job request when not logged in' do
    get new_job_from_job_request_job_path(@job_request)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect new job from job request when logged in as a regular user' do
    log_in_as_regular_user
    get new_job_from_job_request_job_path(@job_request)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect new job from job request when logged in as a customer' do
    log_in_as_customer
    get new_job_from_job_request_job_path(@job_request)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Job.count' do
      post jobs_path
    end
    assert_flash_and_login_url_redirect
  end

  test 'should redirect create when logged in as a regular user' do
    log_in_as_regular_user
    assert_no_difference 'Job.count' do
      post jobs_path
    end
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect create when logged in as a customer' do
    log_in_as_customer
    assert_no_difference 'Job.count' do
      post jobs_path
    end
    assert_flash_and_login_url_redirect
  end

  test 'should get edit when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get edit_job_path(@job)
    assert_template :edit
    assert_manager_dashboard_present_alone
  end

  test 'should redirect edit when not logged in' do
    get edit_job_path(@job)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect edit when logged in as a regular user' do
    log_in_as_regular_user
    get edit_job_path(@job)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect update when not logged in' do
    patch job_path(@job), params: @job_params
    assert_flash_and_login_url_redirect
  end

  test 'should redirect update when logged in as a regular user' do
    log_in_as_regular_user
    patch job_path(@job), params: @job_params
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect update when logged in as a customer' do
    log_in_as_customer
    patch job_path(@job), params: @job_params
    assert_flash_and_login_url_redirect
  end

  test 'should redirect add deaf client to job when not logged in' do
    patch add_deaf_client_to_job_job_path(@job), params: @job_params
    assert_flash_and_login_url_redirect
  end

  test 'should redirect add deaf client to job when logged in as a regular user' do
    log_in_as_regular_user
    patch add_deaf_client_to_job_job_path(@job), params: @job_params
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect add deaf client to job when logged in as a customer' do
    log_in_as_customer
    patch add_deaf_client_to_job_job_path(@job), params: @job_params
    assert_flash_and_login_url_redirect
  end

  test 'should redirect remove deaf client from job when not logged in' do
    get remove_deaf_client_from_job_job_path(@job)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect remove deaf client from job when logged in as a regular user' do
    log_in_as_regular_user
    get remove_deaf_client_from_job_job_path(@job)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect remove deaf client from job when logged in as a customer' do
    log_in_as_customer
    get remove_deaf_client_from_job_job_path(@job)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect add interpreter to job when not logged in' do
    patch add_interpreter_to_job_job_path(@job), params: @job_params
    assert_flash_and_login_url_redirect
  end

  test 'should redirect add interpreter to job when logged in as a regular user' do
    log_in_as_regular_user
    patch add_interpreter_to_job_job_path(@job), params: @job_params
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect add interpreter to job when logged in as a customer' do
    log_in_as_customer
    patch add_interpreter_to_job_job_path(@job), params: @job_params
    assert_flash_and_login_url_redirect
  end

  test 'should redirect remove interpreter from job when not logged in' do
    get remove_interpreter_from_job_job_path(@job)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect remove interpreter from job when logged in as a regular user' do
    log_in_as_regular_user
    get remove_interpreter_from_job_job_path(@job)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect remove interpreter from job when logged in as a customer' do
    log_in_as_customer
    get remove_interpreter_from_job_job_path(@job)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect finalize job and interpreters when not logged in' do
    get finalize_job_and_interpreters_job_path(@job)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect finalize job and interpreters when logged in as a regular user' do
    log_in_as_regular_user
    get finalize_job_and_interpreters_job_path(@job)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect finalize job and interpreters when logged in as a customer' do
    log_in_as_customer
    get finalize_job_and_interpreters_job_path(@job)
    assert_flash_and_login_url_redirect
  end  

  test 'should redirect expire job when not logged in' do
    get expire_job_job_path(@job)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect expire job when logged in as a regular user' do
    log_in_as_regular_user
    get expire_job_job_path(@job)
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect expire job when logged in as a customer' do
    log_in_as_customer
    get expire_job_job_path(@job)
    assert_flash_and_login_url_redirect
  end

  test 'should redirect jobs in need of interpreter when not logged in' do
    get needs_confirmed_interpreter_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect jobs in need of interpreter when logged in as a regular user' do
    log_in_as_regular_user
    get needs_confirmed_interpreter_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect jobs in need of interpreter when logged in as a customer' do
    log_in_as_customer
    get needs_confirmed_interpreter_path
    assert_flash_and_login_url_redirect
  end

  test 'should get jobs in need of interpreter when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get needs_confirmed_interpreter_path
    assert_template :jobs_in_need_of_confirmed_interpreter
    assert_manager_dashboard_present_alone
  end

  test 'should get jobs in need of interpreter when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get needs_confirmed_interpreter_path
    assert_template :jobs_in_need_of_confirmed_interpreter
    assert_manager_dashboard_present_alone
  end

  test 'should redirect awaiting invoice when not logged in' do
    get awaiting_invoice_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect awaiting invoice when logged in as a regular user' do
    log_in_as_regular_user
    get awaiting_invoice_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect awaiting invoice when logged in as a customer' do
    log_in_as_customer
    get awaiting_invoice_path
    assert_flash_and_login_url_redirect
  end

  test 'should get awaiting invoice when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get awaiting_invoice_path
    assert_template :jobs_awaiting_invoice
    assert_manager_dashboard_present_alone
  end

  test 'should get awaiting invoice when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get awaiting_invoice_path
    assert_template :jobs_awaiting_invoice
    assert_manager_dashboard_present_alone
  end

  test 'should redirect processed jobs when not logged in' do
    get processed_jobs_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect processed jobs when logged in as a regular user' do
    log_in_as_regular_user
    get processed_jobs_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect processed jobs when logged in as a customer' do
    log_in_as_customer
    get processed_jobs_path
    assert_flash_and_login_url_redirect
  end

  test 'should get processed jobs when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get processed_jobs_path
    assert_template :processed_jobs
    assert_manager_dashboard_present_alone
  end

  test 'should get processed jobs when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get processed_jobs_path
    assert_template :processed_jobs
    assert_manager_dashboard_present_alone
  end

  test 'should redirect expired jobs when not logged in' do
    get expired_jobs_path
    assert_flash_and_login_url_redirect
  end

  test 'should redirect expired jobs when logged in as a regular user' do
    log_in_as_regular_user
    get expired_jobs_path
    assert_empty_flash_and_root_url_redirect
  end

  test 'should redirect expired jobs when logged in as a customer' do
    log_in_as_customer
    get expired_jobs_path
    assert_flash_and_login_url_redirect
  end

  test 'should get expired jobs when logged in as a manager user with manager dashboard' do
    log_in_as_manager
    get expired_jobs_path
    assert_template :expired_jobs
    assert_manager_dashboard_present_alone
  end

  test 'should get expired jobs when logged in as an admin user with manager dashboard' do
    log_in_as_admin
    get expired_jobs_path
    assert_template :expired_jobs
    assert_manager_dashboard_present_alone
  end
end
