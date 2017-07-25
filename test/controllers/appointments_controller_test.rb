require 'test_helper'

class AppointmentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @appointment = appointments(:one)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Appointment.count' do
      post appointments_path
    end
    assert_flash_and_login_url_redirect
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Appointment.count' do
      delete appointment_path(@appointment)
    end
    assert_flash_and_login_url_redirect
  end
end
