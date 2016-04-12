require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @admin_user = users(:michael)
    @manager_user = users(:sanchez)
    @regular_user = users(:archer)
    @other_user = users(:samson)
    @customer = customers(:university)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect index when not manager" do
    user_log_in_as(@regular_user)
    get :index
    assert_redirected_to root_url
  end

  test "should redirect index when logged in as a customer" do
    customer_log_in_as(@customer)
    get :index
    assert_redirected_to login_url
  end

  test "should redirect show when not logged in" do
    get :show, id: @regular_user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect show when logged in as wrong user" do
    user_log_in_as(@other_user)
    get :show, id: @regular_user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect show when logged in as a customer" do
    customer_log_in_as(@customer)
    get :show, id: @regular_user
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @regular_user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    user_log_in_as(@other_user)
    get :edit, id: @regular_user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @regular_user, user: { first_name: @regular_user.first_name, last_name: @regular_user.last_name,
    																	gender: @regular_user.gender, cell_phone: @regular_user.cell_phone,
                                      email: @regular_user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as wrong user" do
    user_log_in_as(@other_user)
    patch :update, id: @regular_user, user: { first_name: @regular_user.first_name, last_name: @regular_user.last_name,
                                      gender: @regular_user.gender, cell_phone: @regular_user.cell_phone,
                                      email: @regular_user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @regular_user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a regular user" do
    user_log_in_as(@regular_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @regular_user
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a manager" do
    user_log_in_as(@manager_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @regular_user
    end
    assert_redirected_to root_url
  end
end
