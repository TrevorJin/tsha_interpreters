class CreateInterpretingRequests < ActiveRecord::Migration
  def change
    create_table :interpreting_requests do |t|
    	t.integer :user_id
      t.integer :job_id

      t.timestamps null: false
    end
    add_index :interpreting_requests, :user_id
    add_index :interpreting_requests, :job_id
    add_index :interpreting_requests, [:user_id, :job_id], unique: true
  end
end
