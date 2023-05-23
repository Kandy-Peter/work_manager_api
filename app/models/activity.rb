class Activity < ApplicationRecord
  # Scopes
  scope :by_day, ->(start_date, end_date) {
		where(day: start_date.beginning_of_day...end_date.end_of_day) }

  # Associations
  belongs_to :user

  # Validations
  validates_presence_of :day 
end
