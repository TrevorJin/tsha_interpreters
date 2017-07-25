require 'test_helper'

class JobCompletionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @job_completion = job_completions(:one)
  end

  test 'create should require logged-in user' do
    assert_no_difference 'JobCompletion.count' do
      post job_completions_path
    end
    assert_flash_and_login_url_redirect
  end

  test 'destroy should require logged-in user' do
    assert_no_difference 'JobCompletion.count' do
      delete job_completion_path(@job_completion)
    end
    assert_flash_and_login_url_redirect
  end
end
