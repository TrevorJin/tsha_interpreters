require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:michael)
    @customer = customers(:university)
  end

  test 'current_user returns right user when session is nil' do
    user_remember(@user)
    assert_equal @user, current_user
    assert user_is_logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    user_remember(@user)
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test 'current_customer returns right customer when session is nil' do
    customer_remember(@customer)
    assert_equal @customer, current_customer
    assert customer_is_logged_in?
  end

  test 'current_customer returns nil when remember digest is wrong' do
    customer_remember(@customer)
    @customer.update_attribute(:remember_digest, Customer.digest(Customer.new_token))
    assert_nil current_customer
  end
end
