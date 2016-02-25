class Customer < ActiveRecord::Base
	before_save :downcase_email

	validates :customer_name, length: { maximum: 2000, message: "Customer Name must be 2,000 characters or less"}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, length: { maximum: 255, message: "Email must be 255 characters or less" },
	                  format: { with: VALID_EMAIL_REGEX, message: "Email is not a valid email format" }
	validates :contact_first_name, length: { maximum: 50, message: "Contact's First Name must be 50 characters or less" }
	validates :contact_last_name, length: { maximum: 50, message: "Contact's Last Name must be 50 characters or less" }
	validates :billing_address_line_1, length: { maximum: 100, message: "Billing Address line 1 must be 100 characters or less" }
	validates :billing_address_line_2, length: { maximum: 100, message: "Billing Address line 2 must be 100 characters or less" }
	validates :billing_address_line_3, length: { maximum: 100, message: "Billing Address line 3 must be 100 characters or less" }
	validates :mail_address_line_1, length: { maximum: 100, message: "Mail Address line 1 must be 100 characters or less" }
	validates :mail_address_line_2, length: { maximum: 100, message: "Mail Address line 2 must be 100 characters or less" }
	validates :mail_address_line_3, length: { maximum: 100, message: "Mail Address line 3 must be 100 characters or less" }
	validates :phone_number, length: { maximum: 30, message: "Phone number must be 30 characters or less" }
	validates :phone_number_extension, length: { maximum: 20, message: "Phone number extension must be 20 characters or less" }
	validates :fax, length: { maximum: 30, message: "Fax number must be 30 characters or less" }

	private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
end
