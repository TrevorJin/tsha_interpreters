class AddCompletedAndCompletedAtToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :completed, :boolean, default: false
  	add_column :jobs, :completed_at, :datetime
  end
end
