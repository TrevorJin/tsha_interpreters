class Customer < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token
	before_save :downcase_email
  before_create :create_activation_digest

	has_many :jobs
	accepts_nested_attributes_for :jobs

  has_many :job_requests
  accepts_nested_attributes_for :job_requests

	validates :customer_name, presence: { message: "required" },
														length: { maximum: 2000, message: "must be 2,000 characters or less"}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: { message: "required" },
										length: { maximum: 255, message: "must be 255 characters or less" },
	                  format: { with: VALID_EMAIL_REGEX, message: "is not a valid email format" },
	                  uniqueness: { case_sensitive: false, message: "has already been taken" }
  validate :unique_email

	validates :contact_first_name, presence: { message: "required" }, 
																 length: { maximum: 50, message: "must be 50 characters or less" }
	validates :contact_last_name, presence: { message: "required" },
																length: { maximum: 50, message: "must be 50 characters or less" }
	validates :billing_address_line_1, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :billing_address_line_2, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :billing_address_line_3, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :mail_address_line_1, presence: { message: "required" },
                                              length: { maximum: 100, message: "must be 100 characters or less" }
	validates :mail_address_line_2, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :mail_address_line_3, length: { maximum: 100, message: "must be 100 characters or less" }
	# Clean phone number input before validation.
  phony_normalize :phone_number, default_country_code: 'US'
	validates :phone_number, presence: { message: "required" },
                           length: { maximum: 30, message: "must be 30 characters or less" },
													 phony_plausible: true
	# Clean phone number input before validation.
  phony_normalize :contact_phone_number, default_country_code: 'US'
	validates :contact_phone_number, presence: { message: "required" },
                                   length: { maximum: 30, message: "must be 30 characters or less" },
													 				 phony_plausible: true
  # Phone number extension should only have numbers.
	# VALID_PHONE_NUMBER_EXTENSION_REGEX = /^[0-9]*$/
	validates :phone_number_extension, length: { maximum: 20, message: "must be 20 characters or less" }
																		 # format: { with: VALID_PHONE_NUMBER_EXTENSION_REGEX, message: "must only have digits"}
  validates :contact_phone_number_extension, length: { maximum: 20, message: "must be 20 characters or less" }
	validates :fax, length: { maximum: 30, message: "must be 30 characters or less" }

	has_secure_password
	validates :password, presence: { message: "required" },
                       length: { minimum: 6, message: "must be at least 6 characters long" }, allow_nil: true

	def self.search(search, page)
    order(customer_name: :asc).where("cast(id as text) LIKE ? OR customer_name LIKE ? OR contact_first_name LIKE ? OR contact_last_name LIKE ?
                                      OR email LIKE ? OR phone_number LIKE ? OR contact_phone_number LIKE ? OR
                                      billing_address_line_1 LIKE ? OR billing_address_line_2 LIKE ? OR
                                      billing_address_line_3 LIKE ? OR mail_address_line_1 LIKE ? OR
                                      mail_address_line_2 LIKE ? OR mail_address_line_3 LIKE ?" ,
                                      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%",
                                      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%",
                                      "%#{search}%"
                                      ).paginate(page: page, per_page: 20)
  end

  # Returns the hash digest of the given string.
  def Customer.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def Customer.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Customer.new_token
    update_attribute(:remember_digest, Customer.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a customer.
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
    CustomerMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = Customer.new_token
    update_attribute(:reset_digest,  Customer.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    CustomerMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Sends account approved email.
  def send_account_approved_email(approving_manager)
    CustomerMailer.account_approved(self, approving_manager).deliver_now
  end

  # Sends account denied email.
  def send_account_denied_email
    CustomerMailer.account_denied(self).deliver_now
  end

  # Approve customer's account
  def approve_customer_account
    update_attribute(:approved, true)
    update_attribute(:approved_at, Time.zone.now)
  end

  # Deactivate customer's account
  def deactivate_customer
    update_attribute(:active, false)
  end

	private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    def unique_email
      self.email = email.downcase
      self.errors.add(:email, 'is already taken') if User.where(email: self.email).exists?
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = Customer.new_token
      self.activation_digest = Customer.digest(activation_token)
    end
end
