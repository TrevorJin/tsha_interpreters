class CreateJobRejections < ActiveRecord::Migration[4.2]
  def change
    create_table :job_rejections do |t|
    	t.integer :user_id
      t.integer :job_id

      t.timestamps null: false
    end
    add_index :job_rejections, :user_id
    add_index :job_rejections, :job_id
    add_index :job_rejections, [:user_id, :job_id], unique: true
  end
end
