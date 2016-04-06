class AddIndexToAppointments < ActiveRecord::Migration
  def change
  	add_index :appointments, [:job_id, :user_id], unique: true
  end
end
