module CompletionHelper
	def mark_completed_jobs
    @confirmed_and_completed_jobs = Job.where("has_interpreter_assigned = ? AND end < ?", true, Time.now)
    
    @confirmed_and_completed_jobs.each do |confirmed_and_completed_job|
      
      confirmed_and_completed_job.confirmed_interpreters.each do |confirmed_interpreter|
        confirmed_and_completed_job.complete_job(confirmed_interpreter)
      end

      confirmed_and_completed_job.job_complete
    end
  end
end
