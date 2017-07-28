class AddExpiredToJobRequest < ActiveRecord::Migration[4.2]
  def change
  	add_column :job_requests, :expired, :boolean, default: false
  	add_column :job_requests, :expired_at, :datetime
  end
end
