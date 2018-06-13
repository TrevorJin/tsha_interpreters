class AddDeafClientToJobs < ActiveRecord::Migration[5.2]
  def change
  	add_reference :jobs, :deaf_client, foreign_key: true
  end
end
