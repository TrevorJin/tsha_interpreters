class Job < ApplicationRecord
  before_save :downcase_email

  has_many :interpreter_invoices
  has_many :manager_invoices

  has_many :confirmed_interpreter_requests, class_name: "Appointment",
                                            foreign_key: "job_id",
                                            dependent: :destroy
  has_many :confirmed_interpreters, through: :confirmed_interpreter_requests, source: :user

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
  belongs_to :deaf_client

  validates :customer_id, presence: true
  validates :start_date, presence: { message: "start date required" }
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
  validates :requester_phone_number_extension, length: { maximum: 10, message: "must be 10 characters or less" }
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

  def self.search(search, page)
    order(start_date: :desc).where("cast(id as text) LIKE ? OR address_line_1 LIKE ? OR address_line_2 LIKE ? OR
                                    address_line_3 LIKE ? OR requester_first_name LIKE ? OR requester_last_name LIKE ?
                                    OR requester_email LIKE ? OR requester_phone_number LIKE ? OR contact_person_first_name
                                    LIKE ? OR contact_person_last_name LIKE ?", "%#{search}%", "%#{search}%",
                                    "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%",
                                    "%#{search}%", "%#{search}%").paginate(page: page, per_page: 20)
  end

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

  # Checks if job has a deaf client
  def has_deaf_client?
    !self.deaf_client.nil?
  end

  # Adds a deaf client.
  def add_deaf_client(deaf_client)
    self.deaf_client = deaf_client
    self.save
  end

  # Remove a deaf client.
  def remove_deaf_client(deaf_client)
    self.deaf_client = nil
    self.save
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
  def completed_by_user?(user)
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
    update_attribute(:expired, true)
    update_attribute(:expired_at, Time.zone.now)
    if self.confirmed_interpreters.any?
      self.confirmed_interpreters.each do |confirmed_interpreter|
        self.confirmed_interpreters.delete(confirmed_interpreter)
      end
    end
    if self.attempted_interpreters.any?
      self.attempted_interpreters.each do |attempted_interpreter|
        self.attempted_interpreters.delete(attempted_interpreter)
      end
    end
  end

  # Completes a job.
  def job_complete
    update_attribute(:completed, true)
    update_attribute(:completed_at, Time.zone.now)
  end

  # Finalizes job with its interpreters
  def finalize_job_and_interpreters
    update_attribute(:has_interpreter_assigned, true)
    update_attribute(:has_interpreter_assigned_at, Time.zone.now)
    if self.attempted_interpreters.any?
      self.attempted_interpreters.each do |attempted_interpreter|
        self.attempted_interpreters.delete(attempted_interpreter)
      end
    end
  end

  # Marks all invoices as submitted
  def job_status_invoices_submitted
    # self.confirmed_interpreters.each do |confirmed_interpreter|
    #   self.complete_job(confirmed_interpreter)
    #   self.confirmed_interpreters.delete(confirmed_interpreter)
    # end
    
    update_attribute(:invoice_submitted, true)
    update_attribute(:invoice_submitted_at, Time.zone.now)
    
    @interpreter_invoices = self.interpreter_invoices
    @interpreter_invoices.each do |interpreter_invoice|
      interpreter_invoice.job_complete
    end
  end

  # Checks if the job is expired.
  def job_status_expired?
    if self.expired?
      return true
    else
      return false
    end
  end

  # Checks if the job needs interpreter.
  def job_status_needs_interpreter?
    if !self.has_interpreter_assigned? && !self.expired?
      return true
    else
      return false
    end
  end

  # Checks if the job is awaiting invoice.
  def job_status_awaiting_invoice?
    if self.has_interpreter_assigned? && !self.invoice_submitted? && self.completed?
      return true
    else
      return false
    end
  end

  # Checks if the job has reached its final processed state.
  def job_status_processed?
    if self.has_interpreter_assigned? && self.invoice_submitted? && self.completed?
      return true
    else
      return false
    end
  end

  private

    # Converts requester email to all lower-case.
    def downcase_email
      self.requester_email = requester_email.downcase
    end
end
