class Job < ActiveRecord::Base
	validates :start, presence: { message: "date and time required" }
	validates :end, presence: { message: "date and time required" }
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

	has_many :appointments
  has_many :users, through: :appointments
  has_one :customer
  validates_presence_of :customer

  accepts_nested_attributes_for :customer
end
