class AddHasInterpreterAssignedAtToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :has_interpreter_assigned_at, :datetime
  end
end
