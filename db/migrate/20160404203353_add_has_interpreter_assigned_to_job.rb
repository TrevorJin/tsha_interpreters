class AddHasInterpreterAssignedToJob < ActiveRecord::Migration
  def change
  	add_column :jobs, :has_interpreter_assigned, :boolean, default: false
  end
end
