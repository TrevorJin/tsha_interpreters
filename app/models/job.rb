class Job < ActiveRecord::Base
	validates :start, presence: { message: "Start Date and Time Required" }
	validates :end, presence: { message: "End Date and Time Required" }
	validates :address_line_1, presence: { message: "Address Required" },
														 length: { maximum: 100, message: "Address line 1 must be 100 characters or less" }
	validates :address_line_2, length: { maximum: 100, message: "Address line 2 must be 100 characters or less" }
	validates :address_line_3, length: { maximum: 100, message: "Address line 3 must be 100 characters or less" }
	validates :city, presence: { message: "City Required" },
									 length: { maximum: 50, message: "City must be 50 characters or less" }
	validates :state, presence: { message: "State Required" },
										length: { maximum: 30, message: "State must be 30 characters or less" }
	validates :zip, presence: { message: "Zip Code Required" },
									length: { maximum: 20, message: "Zip Code must be 20 characters or less" }
	validates :invoice_notes, length: { maximum: 2000, message: "Invoice notes must be 2,000 characters or less" }
	validates :notes_for_irp, length: { maximum: 2000, message: "Notes for IRP must be 2,000 characters or less" }
	validates :notes_for_interpreter, length: { maximum: 2000, message: "Notes for IRP must be 2,000 characters or less" }
	validates :directions, length: { maximum: 2000, message: "Directions must be 2,000 characters or less" }

	has_many :appointments
  has_many :users, through: :appointments
end
