class DemoRequest < ApplicationRecord
  validates :full_name, :email, :phone_number, :company_name, :company_website, :how_did_you_hear_about_us, presence: true
  validates :company_name, uniqueness: true

  def self.search(query)
    where("company_name ILIKE ?", "%#{query}%")
  end

  enum status: { pending: 0, scheduled: 1, completed: 2, cancelled: 3 }

  def self.statuses_for_select
    statuses.keys.map { |status| [status.titleize, status] }
  end
end
