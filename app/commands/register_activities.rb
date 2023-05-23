class RegisterActivities < PowerTypes::Command.new(:user, :day)
  def perform
    service = UserActivitiesService.new(@user, @day)
      Activity.create!(
        absence: service.absence?,
        worked_too_short: service.worked_too_short?,
        arrived_late: service.arrived_late?,
        finished_too_early: service.finished_too_early?,
        incomplete_assistances: service.incomplete_assistances?,
        day: @day.midnight,
        user: @user
    )
  end
end
