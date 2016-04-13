class CreateInterpreterInvoices < ActiveRecord::Migration
  def change
    create_table :interpreter_invoices do |t|
    	t.datetime :start
      t.datetime :end
      t.string :job_type
      t.string :event_location_address_line_1
    	t.string :event_location_address_line_2
    	t.string :event_location_address_line_3
    	t.string :contact_person_first_name
    	t.string :contact_person_last_name
    	t.string :contact_person_phone_number
    	t.text :interpreter_comments

    	t.timestamps null: false
    end

    add_reference :interpreter_invoices, :user, index: true, foreign_key: true
    add_reference :interpreter_invoices, :job, index: true, foreign_key: true
  end
end
