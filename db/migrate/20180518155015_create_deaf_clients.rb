class CreateDeafClients < ActiveRecord::Migration[5.0]
  def change
    create_table :deaf_clients do |t|
      t.string :first_name
      t.string :last_name
      t.text :internal_notes
      t.text :public_notes

      t.timestamps null: false
    end
  end
end
