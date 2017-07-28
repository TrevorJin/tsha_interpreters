class CreateJobRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :job_requests do |t|
    	t.string :requester_first_name
    	t.string :requester_last_name
    	t.string :office_business_name
    	t.string :requester_email
    	t.string :requester_phone_number
    	t.string :requester_fax_number
    	t.datetime :start
      t.datetime :end
      t.string :deaf_client_first_name
    	t.string :deaf_client_last_name
    	t.string :contact_person_first_name
    	t.string :contact_person_last_name
    	t.string :event_location_address_line_1
    	t.string :event_location_address_line_2
    	t.string :event_location_address_line_3
    	t.string :city
      t.string :state
      t.string :zip
      t.string :office_phone_number
      t.text :type_of_appointment_situation
      t.text :message

    	t.timestamps null: false
    end
  end
end
