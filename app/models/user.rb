class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token, :reset_token
	before_save   :downcase_email
  before_create :create_activation_digest

  has_many :appointments
  has_many :jobs, through: :appointments

	validates :first_name, presence: { message: "required" },
                         length: { maximum: 50, message: "must be 50 characters or less" }
	validates :last_name, presence: { message: "required" },
                        length: { maximum: 50, message: "must be 50 characters or less" }
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

  # Approve interpreter's account
  def approve_interpreter_account
    update_attribute(:approved, true)
    update_attribute(:approved_at, Time.zone.now)
  end

private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
