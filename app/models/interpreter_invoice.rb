class InterpreterInvoice < ActiveRecord::Base
  belongs_to :user
  belongs_to :job

  has_many :manager_invoices

  validates :user_id, presence: true
  validates :job_id, presence: true

  validates :job_type, presence: { message: "required" }, 
																 	 length: { maximum: 50, message: "must be 50 characters or less" }
  validates :event_location_address_line_1, presence: { message: "required" },
                                            length: { maximum: 100, message: "must be 100 characters or less" }
  validates :event_location_address_line_2, length: { maximum: 100, message: "must be 100 characters or less" }
  validates :event_location_address_line_3, length: { maximum: 100, message: "must be 100 characters or less" }
  validates :contact_person_first_name, presence: { message: "required" }, 
                                        length: { maximum: 50, message: "must be 50 characters or less" }
  validates :contact_person_last_name, presence: { message: "required" }, 
                                       length: { maximum: 50, message: "must be 50 characters or less" }
  # Clean phone number input before validation.
  phony_normalize :contact_person_phone_number, default_country_code: 'US'
  validates :contact_person_phone_number, presence: { message: "required" },
                                          length: { maximum: 30, message: "must be 30 characters or less" },
                                          phony_plausible: true
  validates :interpreter_comments, length: { maximum: 2000, message: "must be 2,000 characters or less" }

  def self.search(search, page)
    order(end: :desc).where("cast(id as text) LIKE ? OR job_type LIKE ? OR event_location_address_line_1 LIKE ? OR
                             event_location_address_line_2 LIKE ? OR event_location_address_line_3 LIKE ?
                             OR contact_person_first_name LIKE ? OR contact_person_last_name LIKE ? OR
                             contact_person_phone_number LIKE ?", "%#{search}%", "%#{search}%",
                             "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"
                             ).paginate(page: page, per_page: 20)
  end
end
