class AddIndexToAppointments < ActiveRecord::Migration[4.2]
  def change
  	add_index :appointments, [:job_id, :user_id], unique: true
  end
end
