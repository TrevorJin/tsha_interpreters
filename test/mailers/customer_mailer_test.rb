require 'test_helper'

class CustomerMailerTest < ActionMailer::TestCase
  test "account_activation" do
    customer = customers(:university)
    customer.activation_token = Customer.new_token
    mail = CustomerMailer.account_activation(customer)
    assert_equal "Account activation", mail.subject
    assert_equal [customer.email], mail.to
    assert_equal ["noreply@tshainterpreters.com"], mail.from
    assert_match customer.contact_first_name,   mail.body.encoded
    assert_match customer.contact_last_name,    mail.body.encoded
    assert_match customer.activation_token,     mail.body.encoded
    assert_match CGI::escape(customer.email),   mail.body.encoded
  end

  test "password_reset" do
    customer = customers(:university)
    customer.reset_token = Customer.new_token
    mail = CustomerMailer.password_reset(customer)
    assert_equal "Password reset", mail.subject
    assert_equal [customer.email], mail.to
    assert_equal ["noreply@tshainterpreters.com"], mail.from
    assert_match customer.reset_token,        mail.body.encoded
    assert_match CGI::escape(customer.email), mail.body.encoded
  end

  test "account_approved" do
    manager = users(:michael)
    customer = customers(:shady)
    mail = CustomerMailer.account_approved(customer, manager)
    assert_equal "You have been approved as a customer with TSHA", mail.subject
    assert_equal [customer.email], mail.to
    assert_equal ["noreply@tshainterpreters.com"], mail.from
    assert_match "Your account request with the TSHA system has been approved by", mail.body.encoded
    assert_match "You will now be able to login and request jobs for", mail.body.encoded
    assert_match customer.contact_first_name, mail.body.encoded
    assert_match customer.contact_last_name,  mail.body.encoded
    assert_match manager.first_name,          mail.body.encoded
    assert_match manager.last_name,           mail.body.encoded
    assert_match customer.customer_name,      mail.body.encoded
  end

  test "account_denied" do
    customer = customers(:shady)
    mail = CustomerMailer.account_denied(customer)
    assert_equal "Your account has not been approved by TSHA", mail.subject
    assert_equal [customer.email], mail.to
    assert_equal ["noreply@tshainterpreters.com"], mail.from
    assert_match "Your account request with the TSHA system has not been approved.", mail.body.encoded
    assert_match customer.contact_first_name, mail.body.encoded
    assert_match customer.contact_last_name,  mail.body.encoded
  end
end
