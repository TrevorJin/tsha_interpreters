require 'test_helper'

class InterpreterInvoiceTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(first_name: 'Example', last_name: 'User', gender: 'Male', cell_phone: '+18662466453',
                     email: 'user@example.com', password: 'foobar',
                     password_confirmation: 'foobar')
    @user.save
    @customer = Customer.new(customer_name: 'University of Tulsa', email: 'willywonka@utulsa.edu',
                             contact_first_name: 'Willy', contact_last_name: 'Wonka',
                             billing_address_line_1: '567 5th Avenue', billing_address_line_2: ',
                             billing_address_line_3: ', mail_address_line_1: '567 5th Avenue',
                             mail_address_line_2: '',
                             mail_address_line_3: '', phone_number: '+18662466453',
                             contact_phone_number: '+18662466453', phone_number_extension: '',
                             contact_phone_number_extension: '', fax: '',
                             password: 'foobar', password_confirmation: 'foobar')
    @customer.save
    @job = @customer.jobs.create(start_date: Date.parse('March 3rd 2017'),
                   start_time: DateTime.parse('March 3rd 2017 04:05:06 AM'),
                   requested_end_time: DateTime.parse('March 3rd 2017 05:05:06 AM'),
                   requester_first_name: 'Willy', requester_last_name: 'Wonka',
                   requester_email: 'willy.wonka@gmail.com', requester_phone_number: '+18662466453',
                   contact_person_first_name: 'Willy', contact_person_last_name: 'Wonka',
                   address_line_1: '123 Mulberry Street',
                   address_line_2: '', address_line_3: '', city: 'Tulsa',
                   state: 'Oklahoma', zip: '74104', invoice_notes: 'Park in the rear',
                   notes_for_irp: '', notes_for_interpreter: '', directions: '')
    @interpreter_invoice = InterpreterInvoice.new(start_date: Date.parse('March 3rd 2017'),
                                    start_time: DateTime.parse('March 3rd 2017 04:05:06 AM'),
                                    requested_end_time: DateTime.parse('March 3rd 2017 05:05:06 AM'),
                                    actual_end_time: DateTime.parse('March 3rd 2017 05:05:06 AM'),
                                    job_type: 'Emergency',
                                    event_location_address_line_1: '567 5th Avenue',
                                    event_location_address_line_2: '',
                                    event_location_address_line_3: '',
                                    contact_person_first_name: 'Willy',
                                    contact_person_last_name: 'Wonka',
                                    contact_person_phone_number: '+18662466453',
                                    interpreter_comments: '',
                                    miles: 30, mile_rate: 2.50, misc_travel: 7.50,
                                    interpreting_hours: 3, interpreting_rate: 25,
                                    extra_interpreting_hours: 2,
                                    extra_interpreting_rate: 30,
                                    legal_hours: 3, legal_rate: 37,
                                    extra_legal_hours: 2, extra_legal_rate: 40)
    @interpreter_invoice.job = @job
    @interpreter_invoice.user = @user
    @interpreter_invoice.save
  end

  test 'should be valid' do
    assert @interpreter_invoice.valid?
  end

  test 'should require a user_id' do
    @interpreter_invoice.user_id = nil
    assert_not @interpreter_invoice.valid?
  end

  test 'should require a job_id' do
    @interpreter_invoice.job_id = nil
    assert_not @interpreter_invoice.valid?
  end

  test 'job type should be present' do
    @interpreter_invoice.job_type = '     '
    assert_not @interpreter_invoice.valid?
  end

  test 'job type should not be too long' do
    @interpreter_invoice.job_type = 'a' * 51
    assert_not @interpreter_invoice.valid?
  end

  test 'event location address line 1 should be present' do
    @interpreter_invoice.event_location_address_line_1 = '     '
    assert_not @interpreter_invoice.valid?
  end

  test 'event location address line 1 should not be too long' do
    @interpreter_invoice.event_location_address_line_1 = 'a' * 101
    assert_not @interpreter_invoice.valid?
  end

  test 'event location address line 2 should not be too long' do
    @interpreter_invoice.event_location_address_line_2 = 'a' * 101
    assert_not @interpreter_invoice.valid?
  end

  test 'event location address line 3 should not be too long' do
    @interpreter_invoice.event_location_address_line_3 = 'a' * 101
    assert_not @interpreter_invoice.valid?
  end

  test 'contact person last name should be present' do
    @interpreter_invoice.contact_person_last_name = '     '
    assert_not @interpreter_invoice.valid?
  end

  test 'contact person last name should not be too long' do
    @interpreter_invoice.contact_person_last_name = 'a' * 51
    assert_not @interpreter_invoice.valid?
  end
end
