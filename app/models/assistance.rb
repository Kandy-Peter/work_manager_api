class Assistance <ApplicationRecord
  # ****CALLBACKS****
  before_save :check_previous_assistance
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

  # ****METHODS****

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

  private

  def check_previous_assistance
    beginning_of_day = happened_at.to_date.beginning_of_day
    end_of_day = happened_at.to_date.end_of_day
    previous_assistance = user.assistances.where(happened_at: beginning_of_day..end_of_day)
                                          .order('happened_at DESC')
                                          .first
    if happened_at.to_date > Time.zone.now
      errors.add(:base, "User cannot have an assistance in the future")
    end
    if previous_assistance
      if previous_assistance.kind == kind
        puts "User cannot have two #{kind} in the same day"
        errors.add(:base, "User cannot have two #{kind} without an #{kind == 'in' ? 'out' : 'in'} in the same day")
      elsif previous_assistance.happened_at > happened_at
        errors.add(:base, "User cannot have a #{kind} before an #{previous_assistance.kind}")
      end
    elsif kind == 'out' && previous_assistance.nil?
      errors.add(:base, "User cannot have an exit without any saved entry")
    end

    throw(:abort) if errors.any?
  end
end
