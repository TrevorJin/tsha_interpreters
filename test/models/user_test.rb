require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(first_name: 'Example', last_name: 'User', gender: 'Male', cell_phone: '+18662466453',
                     email: 'user@example.com', password: 'foobar',
                     password_confirmation: 'foobar', vendor_number: 999)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'first name should be present' do
    @user.first_name = '     '
    assert_not @user.valid?
  end

  test 'last name should be present' do
    @user.last_name = '     '
    assert_not @user.valid?
  end

  test 'gender should be present' do
    @user.gender = '     '
    assert_not @user.valid?
  end

  test 'cell phone should be present' do
    @user.cell_phone = '     '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '     '
    assert_not @user.valid?
  end

  test 'first name should not be too long' do
    @user.first_name = 'a' * 51
    assert_not @user.valid?
  end

  test 'last name should not be too long' do
    @user.last_name = 'a' * 51
    assert_not @user.valid?
  end

  test 'cell phone should not be too long' do
    @user.cell_phone = 'a' * 31
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, '#{valid_address.inspect} should be valid'
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'new user should not be an admin' do
    assert_not @user.admin?
  end

  test 'new user should not be a manager' do
    assert_not @user.manager?
  end

  test 'should confirm and unconfirm a job' do
    job = jobs(:one)
    samson  = users(:samson)
    assert_not samson.confirmed?(job)
    samson.confirm_job(job)
    assert samson.confirmed?(job)
    samson.unconfirm_job(job)
    assert_not samson.confirmed?(job)
  end

  test 'should request and unrequest a job' do
    job = jobs(:one)
    samson  = users(:samson)
    assert_not samson.requesting?(job)
    samson.request_job(job)
    assert samson.requesting?(job)
    samson.unrequest_job(job)
    assert_not samson.requesting?(job)
  end

  test 'should complete and uncomplete a job' do
    job = jobs(:one)
    samson  = users(:samson)
    assert_not samson.completed?(job)
    samson.complete_job(job)
    assert samson.completed?(job)
    samson.uncomplete_job(job)
    assert_not samson.completed?(job)
  end

  test 'should reject and unreject a job' do
    job = jobs(:one)
    samson  = users(:samson)
    assert_not samson.rejected?(job)
    samson.reject_job(job)
    assert samson.rejected?(job)
    samson.unreject_job(job)
    assert_not samson.rejected?(job)
  end

  test 'vendor number should be not be a string' do
    @user.vendor_number = 'a'
    assert_not @user.valid?
  end

  test 'fund number should be not be a float' do
    @user.vendor_number = 777.777
    assert_not @user.valid?
  end
end
	