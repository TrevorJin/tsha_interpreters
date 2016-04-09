require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@tshainterpreters.com"], mail.from
    assert_match user.first_name,         mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@tshainterpreters.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test "account_approved" do
    manager = users(:michael)
    user = users(:flaky)
    mail = UserMailer.account_approved(user, manager)
    assert_equal "You have been approved as an interpreter with TSHA", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@tshainterpreters.com"], mail.from
    assert_match "Your account request with the TSHA system has been approved by", mail.body.encoded
    assert_match user.first_name, mail.body.encoded
    assert_match manager.first_name, mail.body.encoded
    assert_match manager.last_name, mail.body.encoded
  end
end
