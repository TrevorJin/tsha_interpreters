class CreateCustomers < ActiveRecord::Migration[4.2]
  def change
    create_table :customers do |t|
      t.string :contact_name

      t.timestamps null: false
    end
  end
end
