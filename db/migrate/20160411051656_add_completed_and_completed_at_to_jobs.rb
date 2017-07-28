class AddCompletedAndCompletedAtToJobs < ActiveRecord::Migration[4.2]
  def change
  	add_column :jobs, :completed, :boolean, default: false
  	add_column :jobs, :completed_at, :datetime
  end
end
