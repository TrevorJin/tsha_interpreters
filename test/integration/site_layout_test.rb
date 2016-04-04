require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin        = users(:michael)
    @manager      = users(:sanchez)
    @regular_user = users(:archer)
    @customer     = customers(:university)
  end

  test "layout links for admin user" do
    user_log_in_as(@admin)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", dashboard_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", user_path(@admin), count: 1
    assert_select "a[href=?]", edit_user_path(@admin), count: 1
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", "http://www.tsha.cc/events/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/contact-us/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/resources/", count: 1
  end

  test "layout links for manager user" do
    user_log_in_as(@manager)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", dashboard_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", user_path(@manager), count: 1
    assert_select "a[href=?]", edit_user_path(@manager), count: 1
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", "http://www.tsha.cc/events/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/contact-us/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/resources/", count: 1
  end

  test "layout links for regular user" do
    user_log_in_as(@regular_user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path,  count: 1
    assert_select "a[href=?]", help_path,  count: 1
    assert_select "a[href=?]", user_path(@regular_user), count: 1
    assert_select "a[href=?]", edit_user_path(@regular_user), count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/"
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/events/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/contact-us/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/resources/", count: 1
  end

  test "layout links when not logged in" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path,  count: 1
    assert_select "a[href=?]", help_path,  count: 1
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/"
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/events/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/contact-us/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/resources/", count: 1
    get interpreter_signup_path
    assert_select "title", full_title("Sign Up As Interpreter")
    get customer_signup_path
    assert_select "title", full_title("Create A Customer")
  end

  test "manager dashboard for admin" do
    user_log_in_as(@admin)
    get dashboard_path
    assert_template 'users/dashboard'
    assert_select "a[href=?]", dashboard_path, count: 2
    assert_select "a[href=?]", pending_interpreters_path, count: 2
    assert_select "a[href=?]", interpreters_path, count: 2
    assert_select "a[href=?]", interpreters_new_path, count: 1
    assert_select "a[href=?]", jobs_path, count: 2
    assert_select "a[href=?]", new_job_path, count: 1
    assert_select "a[href=?]", customers_path, count: 2
    assert_select "a[href=?]", new_customer_path, count: 1
  end

  test "manager dashboard for manager" do
    user_log_in_as(@manager)
    get dashboard_path
    assert_template 'users/dashboard'
    assert_select "a[href=?]", dashboard_path, count: 2
    assert_select "a[href=?]", pending_interpreters_path, count: 2
    assert_select "a[href=?]", interpreters_path, count: 2
    assert_select "a[href=?]", interpreters_new_path, count: 1
    assert_select "a[href=?]", jobs_path, count: 2
    assert_select "a[href=?]", new_job_path, count: 1
    assert_select "a[href=?]", customers_path, count: 2
    assert_select "a[href=?]", new_customer_path, count: 1
  end

  test "layout links for customer" do
    customer_log_in_as(@customer)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path,  count: 1
    assert_select "a[href=?]", help_path,  count: 1
    assert_select "a[href=?]", customer_path(@customer), count: 1
    assert_select "a[href=?]", edit_customer_path(@customer), count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/"
    assert_select "a[href=?]", about_path, count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/events/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/contact-us/", count: 1
    assert_select "a[href=?]", "http://www.tsha.cc/resources/", count: 1
  end
end
