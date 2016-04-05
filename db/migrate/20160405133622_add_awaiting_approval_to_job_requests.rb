class AddAwaitingApprovalToJobRequests < ActiveRecord::Migration
  def change
  	add_column :job_requests, :awaiting_approval, :boolean, default: true
  end
end
