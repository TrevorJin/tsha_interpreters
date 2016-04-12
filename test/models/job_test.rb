require 'test_helper'

class JobTest < ActiveSupport::TestCase
  
  def setup
    @customer = Customer.new(customer_name: "University of Tulsa", email: "willywonka@utulsa.edu",
                             contact_first_name: "Willy", contact_last_name: "Wonka",
                             billing_address_line_1: "567 5th Avenue", billing_address_line_2: "",
                             billing_address_line_3: "", mail_address_line_1: "567 5th Avenue",
                             mail_address_line_2: "",
                             mail_address_line_3: "", phone_number: "+18662466453",
                             contact_phone_number: "+18662466453", phone_number_extension: "",
                             contact_phone_number_extension: "", fax: "",
                             password: "foobar", password_confirmation: "foobar")
    @customer.save
    @job = @customer.jobs.create(start: DateTime.parse('March 3rd 2017 04:05:06 AM'),
    							 end: DateTime.parse('March 4th 2017 04:05:06 AM'),
                   requester_first_name: "Willy", requester_last_name: "Wonka",
                   requester_email: "willy.wonka@gmail.com", requester_phone_number: "+18662466453",
                   contact_person_first_name: "Willy", contact_person_last_name: "Wonka",
    							 address_line_1: "123 Mulberry Street",
    							 address_line_2: "", address_line_3: "", city: "Tulsa",
    							 state: "Oklahoma", zip: "74104", invoice_notes: "Park in the rear",
                   notes_for_irp: "", notes_for_interpreter: "", directions: "")
  end

  test "should be valid" do
    assert @job.valid?
  end

  test "customer id should be present" do
    @job.customer_id = nil
    assert_not @job.valid?
  end

  test "start should be present" do
    @job.start = nil
    assert_not @job.valid?
  end

  test "end should be present" do
    @job.end = nil
    assert_not @job.valid?
  end

  test "requester first name should be present" do
    @job.requester_first_name = "     "
    assert_not @job.valid?
  end

  test "requester first name should not be too long" do
    @job.requester_first_name = "a" * 51
    assert_not @job.valid?
  end

  test "requester last name should be present" do
    @job.requester_last_name = "     "
    assert_not @job.valid?
  end

  test "requester last name should not be too long" do
    @job.requester_last_name = "a" * 51
    assert_not @job.valid?
  end

  test "requester email should be present" do
    @job.requester_email = "     "
    assert_not @job.valid?
  end

  test "requester email should not be too long" do
    @job.requester_email = "a" * 244 + "@example.com"
    assert_not @job.valid?
  end

  test "requester email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @job.requester_email = valid_address
      assert @job.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "requester email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @job.requester_email = mixed_case_email
    @job.save
    assert_equal mixed_case_email.downcase, @job.reload.requester_email
  end

  test "requester phone number should be present" do
    @job.requester_phone_number = "     "
    assert_not @job.valid?
  end

  test "requester phone number should not be too long" do
    @job.requester_phone_number = "+186624664531234567890123456789"
    assert_not @job.valid?
  end

  test "contact person first name should be present" do
    @job.contact_person_first_name = "     "
    assert_not @job.valid?
  end

  test "contact person first name should not be too long" do
    @job.contact_person_first_name = "a" * 51
    assert_not @job.valid?
  end

  test "contact person last name should be present" do
    @job.contact_person_last_name = "     "
    assert_not @job.valid?
  end

  test "contact person last name should not be too long" do
    @job.contact_person_last_name = "a" * 51
    assert_not @job.valid?
  end

  test "address line 1 should be present" do
    @job.address_line_1 = "     "
    assert_not @job.valid?
  end

  test "address line 1 should not be too long" do
    @job.address_line_1 = "a" * 101
    assert_not @job.valid?
  end

  test "address line 2 should not be too long" do
    @job.address_line_2 = "a" * 101
    assert_not @job.valid?
  end

  test "address line 3 should not be too long" do
    @job.address_line_3 = "a" * 101
    assert_not @job.valid?
  end

  test "city should be present" do
    @job.city = nil
    assert_not @job.valid?
  end

  test "city should not be too long" do
    @job.city = "a" * 51
    assert_not @job.valid?
  end

  test "state should be present" do
    @job.state = nil
    assert_not @job.valid?
  end

  test "state should not be too long" do
    @job.state = "a" * 31
    assert_not @job.valid?
  end

  test "zip should be present" do
    @job.zip = nil
    assert_not @job.valid?
  end

  test "zip should not be too long" do
    @job.zip = "a" * 21
    assert_not @job.valid?
  end

  test "invoice notes should not be too long" do
    @job.invoice_notes = "a" * 2001
    assert_not @job.valid?
  end

  test "notes for IRP should not be too long" do
    @job.notes_for_irp = "a" * 2001
    assert_not @job.valid?
  end

  test "notes for interpreter should not be too long" do
    @job.notes_for_interpreter = "a" * 2001
    assert_not @job.valid?
  end

  test "directions should not be too long" do
    @job.directions = "a" * 2001
    assert_not @job.valid?
  end

  test "should confirm and unconfirm a user" do
    job = jobs(:one)
    samson  = users(:samson)
    assert_not job.confirmed?(samson)
    job.confirm_user(samson)
    assert job.confirmed?(samson)
    job.unconfirm_user(samson)
    assert_not job.confirmed?(samson)
  end

  test "should add user's request and remove it" do
    job = jobs(:one)
    samson  = users(:samson)
    assert_not job.requesting?(samson)
    job.add_requester(samson)
    assert job.requesting?(samson)
    job.remove_requester(samson)
    assert_not job.requesting?(samson)
  end

  test "should add link user's job completion and remove it" do
    job = jobs(:one)
    samson  = users(:samson)
    assert_not job.completed_by_user?(samson)
    job.complete_job(samson)
    assert job.completed_by_user?(samson)
    job.uncomplete_job(samson)
    assert_not job.completed_by_user?(samson)
  end

  test "should add link user's job rejection and remove it" do
    job = jobs(:one)
    samson  = users(:samson)
    assert_not job.rejected?(samson)
    job.reject_job(samson)
    assert job.rejected?(samson)
    job.unreject_job(samson)
    assert_not job.rejected?(samson)
  end
end
