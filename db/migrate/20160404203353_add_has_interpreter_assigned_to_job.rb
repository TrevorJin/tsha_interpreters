class AddHasInterpreterAssignedToJob < ActiveRecord::Migration[4.2]
  def change
  	add_column :jobs, :has_interpreter_assigned, :boolean, default: false
  end
end
