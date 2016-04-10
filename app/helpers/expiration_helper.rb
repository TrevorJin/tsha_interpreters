module ExpirationHelper
	def mark_expired_jobs
    @non_expired_active_jobs = Job.where("has_interpreter_assigned = ? AND expired = ?", false, false)
    @non_expired_active_jobs.each do |non_expired_active_job|
      if non_expired_active_job.start < Time.now
        non_expired_active_job.expire_job
      end
    end
  end

  def mark_expired_job_requests
    @non_expired_active_job_requests = JobRequest.where("awaiting_approval = ? AND expired = ?", true, false)
    @non_expired_active_job_requests.each do |non_expired_active_job_request|
      if non_expired_active_job_request.start < Time.now
        non_expired_active_job_request.expire_job_request
      end
    end
  end
end
