class DeafClient < ApplicationRecord
  has_many :jobs

  validates :first_name, presence: { message: "required" }, 
                         length: { maximum: 50, message: "must be 50 characters or less" }
  validates :last_name, presence: { message: "required" },
                        length: { maximum: 50, message: "must be 50 characters or less" }
  validates :internal_notes, length: { maximum: 2000, message: "must be 2,000 characters or less" }
  validates :public_notes, length: { maximum: 2000, message: "must be 2,000 characters or less" }

  def self.search(search, page)
    order(last_name: :asc).where("first_name LIKE ? OR last_name LIKE ?" ,
                                 "%#{search}%", "%#{search}%").paginate(page: page, per_page: 20)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
