class CreateJobs < ActiveRecord::Migration[4.2]
  def change
    create_table :jobs do |t|
      t.datetime :start
      t.datetime :end
      t.string :address_line_1
      t.string :address_line_2
      t.string :address_line_3
      t.string :city
      t.string :state
      t.string :zip
      t.text :invoice_notes
      t.text :notes_for_irp
      t.text :notes_for_interpreter
      t.text :directions

      t.timestamps null: false
    end
  end
end
