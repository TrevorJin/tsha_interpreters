class AddStartDateToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :start_date, :date
  end
end
