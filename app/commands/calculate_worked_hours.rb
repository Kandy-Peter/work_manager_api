class CalculateWorkedHours < PowerTypes::Command.new(:employee, :day)
  def perform
    worked_hours = 0
    assistances = @employee.assistances.by_day(@day.beginning_of_day, @day.end_of_day)
    assistances.each_with_index do |assistance, i|
      date = assistance.happening_at
      worked_hours += (i % 2).zero? ? -date.to_i : date.to_i
    end
    worked_hours / 3600.0
  end
end
