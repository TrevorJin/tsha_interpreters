class Job < ActiveRecord::Base
  before_save :downcase_email

	has_many :confirmed_interpreter_requests, class_name: "Appointment",
																						foreign_key: "job_id",
																						dependent: :destroy
  has_many :confirmed_interpreters, through: :confirmed_interpreter_requests, source: :user
	# has_many :appointments
 #  has_many :users, through: :appointments

  has_many :attempted_interpreter_requests, class_name: "InterpretingRequest",
                                    				foreign_key: "job_id",
                                    				dependent: :destroy
  has_many :attempted_interpreters, through: :attempted_interpreter_requests, source: :user

  has_many :job_completions, class_name: "JobCompletion",
                             foreign_key: "job_id",
                             dependent: :destroy
  has_many :completing_interpreters, through: :job_completions, source: :user

  has_many :job_rejections, class_name: "JobRejection",
                            foreign_key: "job_id",
                            dependent: :destroy
  has_many :rejecting_interpreters, through: :job_rejections, source: :user

  belongs_to :customer

  validates :customer_id, presence: true
	validates :start, presence: { message: "date and time required" }
	validates :end, presence: { message: "date and time required" }
  validates :requester_first_name, presence: { message: "required" }, 
                                   length: { maximum: 50, message: "must be 50 characters or less" }
  validates :requester_last_name, presence: { message: "required" }, 
                                  length: { maximum: 50, message: "must be 50 characters or less" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :requester_email, presence: { message: "required" },
                              length: { maximum: 255, message: "must be 255 characters or less" },
                              format: { with: VALID_EMAIL_REGEX, message: "is not a valid email format" }
  # Clean phone number input before validation.
  phony_normalize :requester_phone_number, default_country_code: 'US'
  validates :requester_phone_number, presence: { message: "required" },
                                     length: { maximum: 30, message: "must be 30 characters or less" },
                                     phony_plausible: true
  validates :contact_person_first_name, presence: { message: "required" }, 
                                        length: { maximum: 50, message: "must be 50 characters or less" }
  validates :contact_person_last_name, presence: { message: "required" }, 
                                       length: { maximum: 50, message: "must be 50 characters or less" }  
	validates :address_line_1, presence: { message: "required" },
														 length: { maximum: 100, message: "must be 100 characters or less" }
	validates :address_line_2, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :address_line_3, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :city, presence: { message: "required" },
									 length: { maximum: 50, message: "must be 50 characters or less" }
	validates :state, presence: { message: "required" },
										length: { maximum: 30, message: "must be 30 characters or less" }
	validates :zip, presence: { message: "required" },
									length: { maximum: 20, message: "must be 20 characters or less" }
	validates :invoice_notes, length: { maximum: 2000, message: "must be 2,000 characters or less" }
	validates :notes_for_irp, length: { maximum: 2000, message: "must be 2,000 characters or less" }
	validates :notes_for_interpreter, length: { maximum: 2000, message: "must be 2,000 characters or less" }
	validates :directions, length: { maximum: 2000, message: "must be 2,000 characters or less" }

	# Confirms a user connection with job
  def confirm_user(user)
    confirmed_interpreter_requests.create(user_id: user.id)
  end

  # Unconfirms a user connection with job
  def unconfirm_user(user)
    confirmed_interpreter_requests.find_by(user_id: user.id).destroy
  end

  # Returns true if the current job is confirmed with this user.
  def confirmed?(user)
    confirmed_interpreters.include?(user)
  end

  # Adds a requesting user.
  def add_requester(user)
    attempted_interpreter_requests.create(user_id: user.id)
  end

  # Remove a requesting user.
  def remove_requester(user)
    attempted_interpreter_requests.find_by(user_id: user.id).destroy
  end

  # Returns true if the current job is requested by this user.
  def requesting?(user)
    attempted_interpreters.include?(user)
  end

  # Confirms a job completion by a user
  def complete_job(user)
    job_completions.create(user_id: user.id)
  end

  # Unconfirms a job completion by a user
  def uncomplete_job(user)
    job_completions.find_by(user_id: user.id).destroy
  end

  # Returns true if the current job is completed by this user.
  def completed?(user)
    completing_interpreters.include?(user)
  end

  # Confirms a job rejection by a user
  def reject_job(user)
    job_rejections.create(user_id: user.id)
  end

  # Unconfirms a job rejection by a user
  def unreject_job(user)
    job_rejections.find_by(user_id: user.id).destroy
  end

  # Returns true if the current job is rejected by this user.
  def rejected?(user)
    rejecting_interpreters.include?(user)
  end

  # Expires a job.
  def expire_job
    update_attribute(:has_interpreter_assigned, false)
    update_attribute(:expired, true)
    update_attribute(:expired_at, Time.zone.now)
  end

  private

    # Converts requester email to all lower-case.
    def downcase_email
      self.requester_email = requester_email.downcase
    end
end
