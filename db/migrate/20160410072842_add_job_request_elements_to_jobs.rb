class AddJobRequestElementsToJobs < ActiveRecord::Migration[4.2]
  def change
  	add_column :jobs, :requester_first_name, :string
  	add_column :jobs, :requester_last_name, :string
  	add_column :jobs, :requester_email, :string
  	add_column :jobs, :requester_phone_number, :string
  	add_column :jobs, :contact_person_first_name, :string
  	add_column :jobs, :contact_person_last_name, :string
  end
end
