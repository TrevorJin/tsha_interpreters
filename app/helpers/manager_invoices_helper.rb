module ManagerInvoicesHelper
	def mark_completed_invoices
    @incomplete_jobs = Job.where("has_interpreter_assigned = ? AND completed = ? AND expired = ? AND 
    															invoice_submitted = ?", true. false, false, false)

  end
end
