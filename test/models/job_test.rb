require 'test_helper'

class JobTest < ActiveSupport::TestCase
  
  def setup
    @customer = Customer.new(customer_name: "University of Tulsa", email: "willywonka@utulsa.edu",
                             contact_first_name: "Willy", contact_last_name: "Wonka",
                             billing_address_line_1: "567 5th Avenue", billing_address_line_2: "",
                             billing_address_line_3: "", mail_address_line_1: "", mail_address_line_2: "",
                             mail_address_line_3: "", phone_number: "+18662466453",
                             contact_phone_number: "+18662466453", phone_number_extension: "",
                             contact_phone_number_extension: "", fax: "")
    @customer.save
    @job = @customer.jobs.create(start: DateTime.parse('March 3rd 2017 04:05:06 AM'),
    							 end: DateTime.parse('March 4th 2017 04:05:06 AM'),
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
end

