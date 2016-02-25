require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  
  def setup
    @customer = Customer.new(contact_first_name: "Samuel", contact_last_name: "Adams",
    							 					 billing_address_line_1: "123 Mulberry Street",
    							 					 billing_address_line_2: "", billing_address_line_3: "",
    							 					 mail_address_line_1: "123 Mulberry Street",
    							 					 mail_address_line_2: "", mail_address_line_3: "",
    							 					 customer_name: "Boster Beer Company",
    							 					 phone_number: "123456789", phone_number_extension: "1",
    							 					 contact_phone_number: "987654321", contact_phone_number_extension: "1",
    							 					 email: "samadams@bostonbeer.com", fax: "111222333")
  end

  test "customer name should not be too long" do
    @customer.customer_name = "a" * 2001
    assert_not @customer.valid?
  end

  test "email should not be too long" do
    @customer.email = "a" * 244 + "@example.com"
    assert_not @customer.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @customer.email = valid_address
      assert @customer.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @customer.email = mixed_case_email
    @customer.save
    assert_equal mixed_case_email.downcase, @customer.reload.email
  end

  test "contact first name should not be too long" do
    @customer.contact_first_name = "a" * 51
    assert_not @customer.valid?
  end

  test "contact last name should not be too long" do
    @customer.contact_last_name = "a" * 51
    assert_not @customer.valid?
  end

  test "billing address line 1 should not be too long" do
    @customer.billing_address_line_1 = "a" * 101
    assert_not @customer.valid?
  end

  test "billing address line 2 should not be too long" do
    @customer.billing_address_line_2 = "a" * 101
    assert_not @customer.valid?
  end

  test "billing address line 3 should not be too long" do
    @customer.billing_address_line_3 = "a" * 101
    assert_not @customer.valid?
  end

  test "mail address line 1 should not be too long" do
    @customer.mail_address_line_1 = "a" * 101
    assert_not @customer.valid?
  end

  test "mail address line 2 should not be too long" do
    @customer.mail_address_line_2 = "a" * 101
    assert_not @customer.valid?
  end

  test "mail address line 3 should not be too long" do
    @customer.mail_address_line_3 = "a" * 101
    assert_not @customer.valid?
  end

  test "phone number should not be too long" do
    @customer.phone_number = "a" * 31
    assert_not @customer.valid?
  end

  test "phone number extension should not be too long" do
    @customer.phone_number_extension = "a" * 31
    assert_not @customer.valid?
  end

  test "fax should not be too long" do
    @customer.fax = "a" * 31
    assert_not @customer.valid?
  end
end
