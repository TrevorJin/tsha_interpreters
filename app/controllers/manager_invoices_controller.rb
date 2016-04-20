class ManagerInvoicesController < ApplicationController
  

  private

    def manager_invoice_params
      params.require(:manager_invoice).permit(:start, :end, :job_type, :event_location_address_line_1, 
                                              :event_location_address_line_2, :event_location_address_line_3,
                                              :contact_person_first_name, :contact_person_last_name,
                                              :contact_person_phone_number, :interpreter_comments, :user_id,
                                              :job_id, :miles, :mile_rate, :interpreting_hours, :interpreting_rate,
                                              :extra_miles, :extra_mile_rate, :extra_interpreting_hours,
                                              :extra_interpreting_rate)
    end

    # Before filters

    # Marks jobs and job requests as expired or completed based on the time.
    def update_job_and_job_request_statuses
      mark_expired_jobs
      mark_expired_job_requests
      mark_completed_jobs
    end
end
