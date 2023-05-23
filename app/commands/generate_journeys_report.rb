class GenerateJourneysReport < PowerTypes::Command.new(:user, :start_date, :end_date)
  class Journey
    include ActiveModel::Serialization
    attr_accessor :id, :day, :assistances, :activities, :worked_hours, :user

    def initialize(day, assistances, activities, work_days, user)
      @day = day.to_date.iso8601
      @assistances = assistances
      @activities = activities
      @worked_hours = work_days.first.total_hours
      @user = user
      @id = "#{user.id}-#{day}"
    end

    def attributes
      {
        'id' => id,
        'day' => day,
        'assistances' => assistances,
        'activities' => activities,
        'worked_hours' => worked_hours,
        'user' => user
      }
    end
  end

  def perform
    assistances = assistances_by_day
    activities = activities_by_day
    work_days = work_days_by_day
    activities.map do |date, _|
      Journey.new(date, assistances[date], activities[date], 
                            work_days[date], @user)
    end
  end

  private

  def assistances_by_day
    @user.assistances.by_day(@start_date, @end_date)
                        .group_by { |a| a. happened_at.getlocal.midnight }
  end

  def activities_by_day
    @user.activities.by_day(@start_date, @end_date)
                      .order(:day)
                      .group_by { |a| a.day.getlocal.midnight }
  end

  def work_days_by_day  
    @user.work_days.by_day(@start_date, @end_date)
                      .group_by { |a| a.day.getlocal.midnight } 
  end
end
