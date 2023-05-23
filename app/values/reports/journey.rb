module Reports
  class Journey

    attr_accessor :id, :day, :assistances, :activities, :worked_hours, :user

    def initialize(day, assistances, activities, work_days, user)
      @day = day.to_date.iso8601
      @assistances = assistances
      @activities = activities
      @worked_hours = work_days.first.total_hours
      @user = user
      @id = "#{user.id}-#{day}"
    end
  end
end
