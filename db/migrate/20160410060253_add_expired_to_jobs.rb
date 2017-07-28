class AddExpiredToJobs < ActiveRecord::Migration[4.2]
  def change
  	add_column :jobs, :expired, :boolean, default: false
  	add_column :jobs, :expired_at, :datetime
  end
end
