class CreateAppointments < ActiveRecord::Migration[4.2]
  def change
    create_table :appointments do |t|
    	t.belongs_to :user, index: true
      t.belongs_to :job, index: true
      t.timestamps null: false
    end
  end
end
