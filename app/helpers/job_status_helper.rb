module JobStatusHelper
  def mark_expired_job_requests
    @non_expired_active_job_requests = JobRequest.where("awaiting_approval = ? AND expired = ?", true, false)
    @non_expired_active_job_requests.each do |non_expired_active_job_request|
      if non_expired_active_job_request.start < Time.now
        non_expired_active_job_request.expire_job_request
      end
    end
  end

  def mark_completed_jobs
    @confirmed_and_completed_jobs = Job.where("has_interpreter_assigned = ? AND completed = ? AND invoice_submitted = ? AND expired = ?", true, false, false, false)
    
    @confirmed_and_completed_jobs.each do |confirmed_and_completed_job|
      
      if confirmed_and_completed_job.end < Time.now
        confirmed_and_completed_job.confirmed_interpreters.each do |confirmed_interpreter|
          confirmed_and_completed_job.complete_job(confirmed_interpreter)
        end

        confirmed_and_completed_job.job_complete
      end
    end
  end

  def update_job_and_job_request_statuses
    mark_expired_job_requests
    mark_completed_jobs
  end
end
