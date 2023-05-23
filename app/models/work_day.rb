class WorkDay < ApplicationRecord

  #****CALBACKS****


  #****SCOPES****
  scope :by_day, ->(start_date, end_date) {
    where(day: start_date.beginning_of_day...end_date.end_of_day) }
      
  #****RELATIONS****
  belongs_to :user

  #****VALIDATIONS****
  validates_presence_of :total_hours, :day
  validates :day, uniqueness: { scope: :user_id,
                                case_sensitive: false,
                                message: "should happen once per user" }
end
