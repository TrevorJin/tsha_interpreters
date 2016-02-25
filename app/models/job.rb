class Job < ActiveRecord::Base
	validates :start, presence: true
	validates :end, presence: true
	validates :address_line_1, presence: { message: "The job must have an address." }, length: { maximum: 100 }
	validates :address_line_2, length: { maximum: 100 }
	validates :address_line_3, length: { maximum: 100 }
	validates :city, presence: { message: "The job must have a city." }
	validates :state, presence: { message: "The job must have a state." }
	validates :zip, presence: { message: "The job must have a zip code." }
	validates :invoice_notes, length: { maximum: 2000, message: "Invoice notes must be less than 2,000 characters." }
	validates :notes_for_irp, length: { maximum: 2000, message: "Notes for IRP must be less than 2,000 characters." }
	validates :notes_for_interpreter, length: { maximum: 2000, message: "Notes for IRP must be less than 2,000 characters." }
	validates :directions, length: { maximum: 2000, message: "Directions must be less than 2,000 characters." }

	has_many :appointments
  has_many :users, through: :appointments
end
