require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  
  def setup
    @customer = Customer.new(contact_first_name: "Samuel", contact_last_name: "Adams",
    							 					 billing_address_line_1: "123 Mulberry Street",
    							 					 billing_address_line_2: "", billing_address_line_3: "",
    							 					 mail_address_line_1: "123 Mulberry Street",
    							 					 mail_address_line_2: "", mail_address_line_3: "",
    							 					 customer_name: "Boster Beer Company",
    							 					 phone_number: "+18662466453", phone_number_extension: "1",
    							 					 contact_phone_number: "+18662466453", contact_phone_number_extension: "1",
    							 					 email: "samadams@bostonbeer.com", fax: "111222333",
                             password: "foobar", password_confirmation: "foobar")
  end

  test "customer name should be present" do
    @customer.customer_name = "     "
    assert_not @customer.valid?
  end

  test "customer name should not be too long" do
    @customer.customer_name = "a" * 2001
    assert_not @customer.valid?
  end

  test "email should be present" do
    @customer.email = "     "
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

  test "email addresses should be unique" do
    duplicate_customer = @customer.dup
    duplicate_customer.email = @customer.email.upcase
    @customer.save
    assert_not duplicate_customer.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @customer.email = mixed_case_email
    @customer.save
    assert_equal mixed_case_email.downcase, @customer.reload.email
  end

  test "contact first name should be present" do
    @customer.contact_first_name = "     "
    assert_not @customer.valid?
  end

  test "contact first name should not be too long" do
    @customer.contact_first_name = "a" * 51
    assert_not @customer.valid?
  end

  test "contact last name should be present" do
    @customer.contact_last_name = "     "
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

  test "mail address line 1 should be present" do
    @customer.mail_address_line_1 = "     "
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

  test "phone number should be present" do
    @customer.phone_number = "     "
    assert_not @customer.valid?
  end

  test "phone number should not be too long" do
    @customer.phone_number = "+186624664531234567890123456789"
    assert_not @customer.valid?
  end

  test "contact phone number should be present" do
    @customer.contact_phone_number = "     "
    assert_not @customer.valid?
  end

  test "contact phone number should not be too long" do
    @customer.contact_phone_number = "+186624664531234567890123456789"
    assert_not @customer.valid?
  end

  test "phone number extension should not be too long" do
    @customer.phone_number_extension = "1" * 21
    assert_not @customer.valid?
  end

  # test "phone number extension should not have non-numeric characters" do
  #   @customer.phone_number_extension = "abc123"
  #   assert_not @customer.valid?
  # end

  test "contact phone number extension should not be too long" do
    @customer.contact_phone_number_extension = "1" * 21
    assert_not @customer.valid?
  end

  test "fax should not be too long" do
    @customer.fax = "a" * 31
    assert_not @customer.valid?
  end

  test "password should be present (nonblank)" do
    @customer.password = @customer.password_confirmation = " " * 6
    assert_not @customer.valid?
  end

  test "password should have a minimum length" do
    @customer.password = @customer.password_confirmation = "a" * 5
    assert_not @customer.valid?
  end

end
