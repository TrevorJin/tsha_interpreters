class JobCompletion < ApplicationRecord
	belongs_to :user, class_name: "User"
  belongs_to :job, class_name: "Job"
  validates :user_id, presence: true
  validates :job_id, presence: true
end
