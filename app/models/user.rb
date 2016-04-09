class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save   :downcase_email
  before_create :create_activation_digest

  has_many :confirmed_job_requests, class_name: "Appointment",
                                    foreign_key: "user_id",
                                    dependent: :destroy
  has_many :confirmed_jobs, through: :confirmed_job_requests, source: :job

  # has_many :appointments
  # has_many :jobs, through: :appointments

  has_many :attempted_job_requests, class_name: "InterpretingRequest",
                                    foreign_key: "user_id",
                                    dependent: :destroy
  has_many :attempted_jobs, through: :attempted_job_requests, source: :job

  has_many :completions, class_name: "JobCompletion",
                         foreign_key: "user_id",
                         dependent: :destroy
  has_many :completed_jobs, through: :completions, source: :job

  has_many :rejections, class_name: "JobRejection",
                        foreign_key: "user_id",
                        dependent: :destroy
  has_many :rejected_jobs, through: :rejections, source: :job

	validates :first_name, presence: { message: "required" },
                         length: { maximum: 50, message: "must be 50 characters or less" }
	validates :last_name, presence: { message: "required" },
                        length: { maximum: 50, message: "must be 50 characters or less" }
  validates :gender, presence: { message: "required" }

  # Clean phone number input before validation.
  phony_normalize :cell_phone, default_country_code: 'US'
	validates :cell_phone, presence: { message: "required" },
                         length: { maximum: 30, message: "must be 30 characters or less" },
                         phony_plausible: true

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: { message: "required" },
                    length: { maximum: 255, message: "must be 255 characters or less" },
	                  format: { with: VALID_EMAIL_REGEX, message: "is not a valid email format" },
	                  uniqueness: { case_sensitive: false, message: "has already been taken" }
  validate :unique_email
	
  has_secure_password
	validates :password, presence: { message: "required" },
                       length: { minimum: 6, message: "must be at least 6 characters long" }, allow_nil: true

  def self.search(search, page)
    order(admin: :desc, manager: :desc, last_name: :asc, first_name: :asc).where("last_name LIKE ? OR first_name like ?" , "%#{search}%", "%#{search}%").paginate(page: page, per_page: 20)
  end

  # def self.search(query)
  #   # where(:title, query) -> This would return an exact match of the query
  #   #where("last_name like ?", "%#{query}%")
  #   where("last_name LIKE ? OR first_name like ?" , "%#{query}%", "%#{query}%")
  # end

	# Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Sends account approved email.
  def send_account_approved_email(approving_manager)
    UserMailer.account_approved(self, approving_manager).deliver_now
  end

  # Approve interpreter's account
  def approve_interpreter_account
    update_attribute(:approved, true)
    update_attribute(:approved_at, Time.zone.now)
  end

  # Deactivate user's account
  def deactivate_user
    update_attribute(:active, false)
  end

  # Change to manager.
  def change_to_manager
    update_attribute(:manager,  true)
    update_attribute(:admin,    false)
  end

  # Change to admin.
  def change_to_admin
    update_attribute(:manager,  true)
    update_attribute(:admin,    true)
  end

  # Change to interpreter
  def change_to_interpreter
    update_attribute(:manager,  false)
    update_attribute(:admin,    false)
  end

  # Confirms a job connection with user.
  def confirm_job(job)
    confirmed_job_requests.create(job_id: job.id)
  end

  # Unconfirms a job connection with user.
  def unconfirm_job(job)
    confirmed_job_requests.find_by(job_id: job.id).destroy
  end

  # Returns true if the current user is confirmed with this job.
  def confirmed?(job)
    confirmed_jobs.include?(job)
  end

  # Request a job.
  def request_job(job)
    attempted_job_requests.create(job_id: job.id)
  end

  # Un-request a job.
  def unrequest_job(job)
    attempted_job_requests.find_by(job_id: job.id).destroy
  end

  # Returns true if the current user is requesting this job.
  def requesting?(job)
    attempted_jobs.include?(job)
  end

  # Confirms the completion of a job.
  def complete_job(job)
    completions.create(job_id: job.id)
  end

  # Uncompletes the completion of a job.
  def uncomplete_job(job)
    completions.find_by(job_id: job.id).destroy
  end

  # Returns true if the current user completed this job.
  def completed?(job)
    completed_jobs.include?(job)
  end

  # Confirms the rejection of a job.
  def reject_job(job)
    rejections.create(job_id: job.id)
  end

  # Unrejects the rejection of a job.
  def unreject_job(job)
    rejections.find_by(job_id: job.id).destroy
  end

  # Returns true if the current user rejected this job.
  def rejected?(job)
    rejected_jobs.include?(job)
  end

  def promote_qualification(qualification)
    if (qualification == "QAST I Interpreting")
      update_attribute(:qast_1_interpreting,  true)
    elsif (qualification == "QAST II Interpreting")
      update_attribute(:qast_2_interpreting,  true)
    elsif (qualification == "QAST III Interpreting")
      update_attribute(:qast_3_interpreting,  true)
    elsif (qualification == "QAST IV Interpreting")
      update_attribute(:qast_4_interpreting,  true)
    elsif (qualification == "QAST V Interpreting")
      update_attribute(:qast_5_interpreting,  true)
    elsif (qualification == "QAST I Transliterating")
      update_attribute(:qast_1_transliterating,  true)
    elsif (qualification == "QAST II Transliterating")
      update_attribute(:qast_2_transliterating,  true)
    elsif (qualification == "QAST III Transliterating")
      update_attribute(:qast_3_transliterating,  true)
    elsif (qualification == "QAST IV Transliterating")
      update_attribute(:qast_4_transliterating,  true)
    elsif (qualification == "QAST V Transliterating")
      update_attribute(:qast_5_transliterating,  true)
    elsif (qualification == "RID CI")
      update_attribute(:rid_ci,  true)
    elsif (qualification == "RID CT")
      update_attribute(:rid_ct,  true)
    elsif (qualification == "RID CDI")
      update_attribute(:rid_cdi,  true)
    elsif (qualification == "DI")
      update_attribute(:di,  true)
    elsif (qualification == "NIC")
      update_attribute(:nic,  true)
    elsif (qualification == "NIC Advanced")
      update_attribute(:nic_advanced,  true)
    elsif (qualification == "NIC Master")
      update_attribute(:nic_master,  true)
    elsif (qualification == "RID SC:L")
      update_attribute(:rid_sc_l,  true)
    end
  end

  def revoke_qualification(qualification)
    if (qualification == "QAST I Interpreting")
      update_attribute(:qast_1_interpreting,  false)
    elsif (qualification == "QAST II Interpreting")
      update_attribute(:qast_2_interpreting,  false)
    elsif (qualification == "QAST III Interpreting")
      update_attribute(:qast_3_interpreting,  false)
    elsif (qualification == "QAST IV Interpreting")
      update_attribute(:qast_4_interpreting,  false)
    elsif (qualification == "QAST V Interpreting")
      update_attribute(:qast_5_interpreting,  false)
    elsif (qualification == "QAST I Transliterating")
      update_attribute(:qast_1_transliterating,  false)
    elsif (qualification == "QAST II Transliterating")
      update_attribute(:qast_2_transliterating,  false)
    elsif (qualification == "QAST III Transliterating")
      update_attribute(:qast_3_transliterating,  false)
    elsif (qualification == "QAST IV Transliterating")
      update_attribute(:qast_4_transliterating,  false)
    elsif (qualification == "QAST V Transliterating")
      update_attribute(:qast_5_transliterating,  false)
    elsif (qualification == "RID CI")
      update_attribute(:rid_ci,  false)
    elsif (qualification == "RID CT")
      update_attribute(:rid_ct,  false)
    elsif (qualification == "RID CDI")
      update_attribute(:rid_cdi,  false)
    elsif (qualification == "DI")
      update_attribute(:di,  false)
    elsif (qualification == "NIC")
      update_attribute(:nic,  false)
    elsif (qualification == "NIC Advanced")
      update_attribute(:nic_advanced,  false)
    elsif (qualification == "NIC Master")
      update_attribute(:nic_master,  false)
    elsif (qualification == "RID SC:L")
      update_attribute(:rid_sc_l,  false)
    end
  end

  def eligible_jobs
    eligible_jobs_array = Array.new
    available_jobs = Job.where("start > ?", Time.now)
    
    available_jobs.each do |job|
      this_is_an_eligible_job = true
      if self.requesting?(job) || self.confirmed?(job)
        # Interpreter already connected to this job
        this_is_an_eligible_job = false
      else
        if job.qast_1_interpreting_required
          if self.qast_1_interpreting
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_2_interpreting_required
          if self.qast_2_interpreting
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_3_interpreting_required
          if self.qast_3_interpreting
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_4_interpreting_required
          if self.qast_4_interpreting
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_5_interpreting_required
          if self.qast_5_interpreting
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_1_transliterating_required_required
          if self.qast_1_transliterating
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_2_transliterating_required
          if self.qast_2_transliterating
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_3_transliterating_required
          if self.qast_3_transliterating
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_4_transliterating_required
          if self.qast_4_transliterating
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.qast_5_transliterating_required
          if self.qast_5_transliterating
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.rid_ci_required
          if self.rid_ci
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.rid_ct_required
          if self.rid_ct
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.rid_cdi_required
          if self.rid_cdi
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.di_required
          if self.di
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.nic_required
          if self.nic
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.nic_advanced_required
          if self.nic_advanced
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.nic_master_required
          if self.nic_master
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
        if job.rid_sc_l_required
          if self.rid_sc_l
            # Interpreter is qualified here, continue.
          else
            this_is_an_eligible_job = false
          end
        end
      end

      if this_is_an_eligible_job
        eligible_jobs_array.push job
      end
    end

    return eligible_jobs_array
  end

private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    def unique_email
      self.errors.add(:email, 'is already taken') if Customer.where(email: self.email).exists?
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
