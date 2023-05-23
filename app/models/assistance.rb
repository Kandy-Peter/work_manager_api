class Assistance <ApplicationRecord
  # ****CALLBACKS****
  # Calculate worked hours, and activities for every assistance of kind 'out' save
  after_save :set_worked_hours
  after_save :update_user_activities

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

  # ****Update user activities****
  def update_user_activities
    if out?
      date = happened_at.getlocal.midnight
      RegisterActivities.for(user: user, day: date)                         
    end
  end

end
