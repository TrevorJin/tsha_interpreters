class Customer < ActiveRecord::Base
	before_save :downcase_email

	has_many :jobs
	accepts_nested_attributes_for :jobs

	validates :customer_name, presence: { message: "required" },
														length: { maximum: 2000, message: "must be 2,000 characters or less"}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: { message: "required" },
										length: { maximum: 255, message: "must be 255 characters or less" },
	                  format: { with: VALID_EMAIL_REGEX, message: "is not a valid email format" }
	validates :contact_first_name, presence: { message: "required" }, 
																 length: { maximum: 50, message: "must be 50 characters or less" }
	validates :contact_last_name, presence: { message: "required" },
																length: { maximum: 50, message: "must be 50 characters or less" }
	validates :billing_address_line_1, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :billing_address_line_2, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :billing_address_line_3, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :mail_address_line_1, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :mail_address_line_2, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :mail_address_line_3, length: { maximum: 100, message: "must be 100 characters or less" }
	# Clean phone number input before validation.
  phony_normalize :phone_number, default_country_code: 'US'
	validates :phone_number, length: { maximum: 30, message: "must be 30 characters or less" },
													 phony_plausible: true
													 # Clean phone number input before validation.
  phony_normalize :contact_phone_number, default_country_code: 'US'
	validates :contact_phone_number, length: { maximum: 30, message: "must be 30 characters or less" },
													 				 phony_plausible: true
  # Phone number extension should only have numbers.
	# VALID_PHONE_NUMBER_EXTENSION_REGEX = /^[0-9]*$/
	validates :phone_number_extension, length: { maximum: 20, message: "must be 20 characters or less" }
																		 # format: { with: VALID_PHONE_NUMBER_EXTENSION_REGEX, message: "must only have digits"}
  validates :contact_phone_number_extension, length: { maximum: 20, message: "must be 20 characters or less" }
	validates :fax, length: { maximum: 30, message: "must be 30 characters or less" }

	private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
end
