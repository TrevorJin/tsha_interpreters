class CreateManagerInvoices < ActiveRecord::Migration
  def change
    create_table :manager_invoices do |t|
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
    	t.decimal :miles
    	t.decimal :mile_rate
    	t.decimal :interpreting_hours
    	t.decimal :interpreting_rate
    	t.decimal :extra_miles
    	t.decimal :extra_mile_rate
    	t.decimal :extra_interpreting_hours
    	t.decimal :extra_interpreting_rate
    	t.boolean :job_completed, default: false
    	t.datetime :job_completed_at

    	t.timestamps null: false
    end

    add_reference :manager_invoices, :user, index: true, foreign_key: true
    add_reference :manager_invoices, :job, index: true, foreign_key: true
    add_reference :manager_invoices, :interpreter_invoice, index: true, foreign_key: true
  end
end
