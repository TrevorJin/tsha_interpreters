class RemoveActualEndTimeFromJob < ActiveRecord::Migration[5.2]
  def change
  	remove_column :jobs, :actual_end_time
  end
end
