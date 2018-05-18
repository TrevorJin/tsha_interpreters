module JobStatusHelper
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
    mark_completed_jobs
  end
end
