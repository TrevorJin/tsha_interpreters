require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  
  def setup
    @appointment = Appointment.new(user_id: 1, job_id: 2)
  end

  test 'should be valid' do
    assert @appointment.valid?
  end

  test 'should require a user_id' do
    @appointment.user_id = nil
    assert_not @appointment.valid?
  end

  test 'should require a job_id' do
    @appointment.job_id = nil
    assert_not @appointment.valid?
  end
end
