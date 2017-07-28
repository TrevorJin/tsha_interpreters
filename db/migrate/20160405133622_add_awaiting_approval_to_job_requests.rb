class AddAwaitingApprovalToJobRequests < ActiveRecord::Migration[4.2]
  def change
  	add_column :job_requests, :awaiting_approval, :boolean, default: true
  end
end
