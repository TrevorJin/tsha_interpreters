require 'test_helper'

class JobRequestTest < ActiveSupport::TestCase
  
  def setup
    @customer = Customer.new(customer_name: "University of Tulsa", email: "willywonka@utulsa.edu",
                             contact_first_name: "Willy", contact_last_name: "Wonka",
                             billing_address_line_1: "567 5th Avenue", billing_address_line_2: "",
                             billing_address_line_3: "", mail_address_line_1: "", mail_address_line_2: "",
                             mail_address_line_3: "", phone_number: "+18662466453",
                             contact_phone_number: "+18662466453", phone_number_extension: "",
                             contact_phone_number_extension: "", fax: "",
                             password: "foobar", password_confirmation: "foobar")
    @customer.save
    @job_request = @customer.job_requests.create(requester_first_name: "Billy", requester_last_name: "Hamilton",
                                                 office_business_name: "Cincinnati Reds",
                                                 requester_email: "billy.hamilton@cincinnatireds.com",
                                                 requester_phone_number: "+18662466453", requester_fax_number: "",
                                                 start: DateTime.parse('May 3rd 2017 04:05:06 AM'),
                                                 end: DateTime.parse('May 4th 2017 04:05:06 AM'),
                                                 deaf_client_first_name: "Dusty", deaf_client_last_name: "Baker",
                                                 contact_person_first_name: "Alexander",
                                                 contact_person_last_name: "Hamilton",
                                                 event_location_address_line_1: "5000 Emerald Lane",
                                                 event_location_address_line_2: "", event_location_address_line_3: "",
                                                 city: "Cincinnati", state: "Ohio", zip: "45201",
                                                 office_phone_number: "+18662466453",
                                                 type_of_appointment_situation: "Can't hear the umpire well enough.",
                                                 message: "Please help us.")
  end

  test "should be valid" do
    assert @job_request.valid?
  end

  test "customer id should be present" do
    @job_request.customer_id = nil
    assert_not @job_request.valid?
  end

  test "requester first name should be present" do
    @job_request.requester_first_name = "     "
    assert_not @job_request.valid?
  end

  test "requester first name should not be too long" do
    @job_request.requester_first_name = "a" * 51
    assert_not @job_request.valid?
  end

  test "requester last name should be present" do
    @job_request.requester_last_name = "     "
    assert_not @job_request.valid?
  end

  test "requester last name should not be too long" do
    @job_request.requester_last_name = "a" * 51
    assert_not @job_request.valid?
  end

  test "office/business name should be present" do
    @job_request.office_business_name = "     "
    assert_not @job_request.valid?
  end

  test "office/business name should not be too long" do
    @job_request.office_business_name = "a" * 2001
    assert_not @job_request.valid?
  end

  test "requester email should be present" do
    @job_request.requester_email = "     "
    assert_not @job_request.valid?
  end

  test "requester email should not be too long" do
    @job_request.requester_email = "a" * 244 + "@example.com"
    assert_not @job_request.valid?
  end

  test "requester email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @job_request.requester_email = valid_address
      assert @job_request.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "requester email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @job_request.requester_email = mixed_case_email
    @job_request.save
    assert_equal mixed_case_email.downcase, @job_request.reload.requester_email
  end

  test "requester phone number should be present" do
    @job_request.requester_phone_number = "     "
    assert_not @job_request.valid?
  end

  test "requester phone number should not be too long" do
    @job_request.requester_phone_number = "+186624664531234567890123456789"
    assert_not @job_request.valid?
  end

  test "requester fax number should not be too long" do
    @job_request.requester_fax_number = "a" * 31
    assert_not @job_request.valid?
  end

  test "start should be present" do
    @job_request.start = nil
    assert_not @job_request.valid?
  end

  test "end should be present" do
    @job_request.end = nil
    assert_not @job_request.valid?
  end

  test "deaf client first name should be present" do
    @job_request.deaf_client_first_name = "     "
    assert_not @job_request.valid?
  end

  test "deaf client first name should not be too long" do
    @job_request.deaf_client_first_name = "a" * 51
    assert_not @job_request.valid?
  end

  test "deaf client last name should be present" do
    @job_request.deaf_client_last_name = "     "
    assert_not @job_request.valid?
  end

  test "deaf client last name should not be too long" do
    @job_request.deaf_client_last_name = "a" * 51
    assert_not @job_request.valid?
  end

  test "contact person first name should be present" do
    @job_request.contact_person_first_name = "     "
    assert_not @job_request.valid?
  end

  test "contact person first name should not be too long" do
    @job_request.contact_person_first_name = "a" * 51
    assert_not @job_request.valid?
  end

  test "contact person last name should be present" do
    @job_request.contact_person_last_name = "     "
    assert_not @job_request.valid?
  end

  test "contact person last name should not be too long" do
    @job_request.contact_person_last_name = "a" * 51
    assert_not @job_request.valid?
  end

  test "event location address line 1 should be present" do
    @job_request.event_location_address_line_1 = "     "
    assert_not @job_request.valid?
  end

  test "event location address line 1 should not be too long" do
    @job_request.event_location_address_line_1 = "a" * 101
    assert_not @job_request.valid?
  end

  test "event location address line 2 should not be too long" do
    @job_request.event_location_address_line_2 = "a" * 101
    assert_not @job_request.valid?
  end

  test "event location address line 3 should not be too long" do
    @job_request.event_location_address_line_3 = "a" * 101
    assert_not @job_request.valid?
  end

  test "city should be present" do
    @job_request.city = nil
    assert_not @job_request.valid?
  end

  test "city should not be too long" do
    @job_request.city = "a" * 51
    assert_not @job_request.valid?
  end

  test "state should be present" do
    @job_request.state = nil
    assert_not @job_request.valid?
  end

  test "state should not be too long" do
    @job_request.state = "a" * 31
    assert_not @job_request.valid?
  end

  test "zip should be present" do
    @job_request.zip = nil
    assert_not @job_request.valid?
  end

  test "zip should not be too long" do
    @job_request.zip = "a" * 21
    assert_not @job_request.valid?
  end

  test "office phone number should be present" do
    @job_request.office_phone_number = "     "
    assert_not @job_request.valid?
  end

  test "office phone number should not be too long" do
    @job_request.office_phone_number = "+186624664531234567890123456789"
    assert_not @job_request.valid?
  end

  test "type of appointment should not be too long" do
    @job_request.type_of_appointment_situation = "a" * 2001
    assert_not @job_request.valid?
  end

  test "message should not be too long" do
    @job_request.message = "a" * 2001
    assert_not @job_request.valid?
  end
end

