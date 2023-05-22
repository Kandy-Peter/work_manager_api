class Assistance <ApplicationRecord
  # ****CALLBACKS****
  # Calculate worked hours for every assistance of kind 'out' save
  after_save :set_worked_hours

  # ****SCOPES****
  scope :by_day, ->(start_date, end_date) {
    start_datetime = start_date.to_datetime.beginning_of_day
    end_datetime = end_date.to_datetime.end_of_day
    where(happened_at: start_datetime..end_datetime)
  }

  # ****VALIDATIONS****
  validates :kind, :happened_at, presence: true

  # ****ENUMS****
  enum kind: [:in, :out]

  # ****RELATIONS****
  belongs_to :user

  # ****Update work hours****
  def set_worked_hours
    if out?
      hours = CalculateWorkedHours.for(user: user, day: happened_at)
      date = happened_at.getlocal.midnight
      work_day = WorkDay.find_or_initialize_by(day: date, user: user)
      work_day.update(total_hours: hours)                              
    end
  end

  # if there to kind "in" records in the same day, update the last one
  def self.update_in_assistance(user, date)
    assistance = Assistance.find_by(user: user, kind: :in, happened_at: date.beginning_of_day..date.end_of_day)
    assistance.update(happened_at: Time.current) if assistance.present?
  end
end
