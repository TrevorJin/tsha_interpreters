class AddHasInterpreterAssignedAtToJobs < ActiveRecord::Migration[4.2]
  def change
  	add_column :jobs, :has_interpreter_assigned_at, :datetime
  end
end
