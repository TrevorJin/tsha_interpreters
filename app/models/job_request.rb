class JobRequest < ActiveRecord::Base
  before_save :downcase_email

  belongs_to :customer
  belongs_to :job

  validates :customer_id, presence: true
  validates :requester_first_name, presence: { message: "required" }, 
																 	 length: { maximum: 50, message: "must be 50 characters or less" }
  validates :requester_last_name, presence: { message: "required" }, 
																 	length: { maximum: 50, message: "must be 50 characters or less" }
  validates :office_business_name, presence: { message: "required" },
																	 length: { maximum: 2000, message: "must be 2,000 characters or less"}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :requester_email, presence: { message: "required" },
															length: { maximum: 255, message: "must be 255 characters or less" },
	                  					format: { with: VALID_EMAIL_REGEX, message: "is not a valid email format" }
  # Clean phone number input before validation.
  phony_normalize :requester_phone_number, default_country_code: 'US'
	validates :requester_phone_number, presence: { message: "required" },
																		 length: { maximum: 30, message: "must be 30 characters or less" },
													 					 phony_plausible: true
  validates :requester_fax_number, length: { maximum: 30, message: "must be 30 characters or less" }
  validates :start, presence: { message: "date and time required" }
	validates :end, presence: { message: "date and time required" }
	validates :deaf_client_first_name, presence: { message: "required" }, 
																 	 	 length: { maximum: 50, message: "must be 50 characters or less" }
  validates :deaf_client_last_name, presence: { message: "required" }, 
																 		length: { maximum: 50, message: "must be 50 characters or less" }
	validates :contact_person_first_name, presence: { message: "required" }, 
																 	 	 		length: { maximum: 50, message: "must be 50 characters or less" }
  validates :contact_person_last_name, presence: { message: "required" }, 
																 			 length: { maximum: 50, message: "must be 50 characters or less" }															 		
  validates :event_location_address_line_1, presence: { message: "required" },
														 							  length: { maximum: 100, message: "must be 100 characters or less" }
	validates :event_location_address_line_2, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :event_location_address_line_3, length: { maximum: 100, message: "must be 100 characters or less" }
	validates :city, presence: { message: "required" },
									 length: { maximum: 50, message: "must be 50 characters or less" }
	validates :state, presence: { message: "required" },
										length: { maximum: 30, message: "must be 30 characters or less" }
	validates :zip, presence: { message: "required" },
									length: { maximum: 20, message: "must be 20 characters or less" }
  # Clean phone number input before validation.
  phony_normalize :office_phone_number, default_country_code: 'US'
	validates :office_phone_number, presence: { message: "required" },
																	length: { maximum: 30, message: "must be 30 characters or less" },
													 				phony_plausible: true
  validates :type_of_appointment_situation, length: { maximum: 2000, message: "must be 2,000 characters or less" }
  validates :message, length: { maximum: 2000, message: "must be 2,000 characters or less" }

  private

    # Converts requester email to all lower-case.
    def downcase_email
      self.requester_email = requester_email.downcase
    end
end