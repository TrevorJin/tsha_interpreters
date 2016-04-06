class AddAcceptedAndDeniedToJobRequest < ActiveRecord::Migration
  def change
  	add_column :job_requests, :accepted, :boolean, default: false
  	add_column :job_requests, :accepted_at, :datetime
  	add_column :job_requests, :denied, :boolean, default: false
  	add_column :job_requests, :denied_at, :datetime
  end
end
