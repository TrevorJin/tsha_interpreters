class AddExpiredToJobs < ActiveRecord::Migration
  def change
  	add_column :jobs, :expired, :boolean, default: false
  	add_column :jobs, :expired_at, :datetime
  end
end
