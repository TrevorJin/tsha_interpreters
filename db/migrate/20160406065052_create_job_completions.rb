class CreateJobCompletions < ActiveRecord::Migration
  def change
    create_table :job_completions do |t|
    	t.integer :user_id
      t.integer :job_id

      t.timestamps null: false
    end
    add_index :job_completions, :user_id
    add_index :job_completions, :job_id
    add_index :job_completions, [:user_id, :job_id], unique: true
  end
end
