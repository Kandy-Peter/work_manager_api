# db/seeds.rb

# Load seed files from the seeds folder
Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  load file
end

orgIds = Organization.all.pluck(:id)

users = User.all.where(organization_id: orgIds[0])
department = Department.all.where(organization_id: orgIds[0])
usersId = User.all.where(organization_id: orgIds[0]).pluck(:id)

users.each do |user|
  department.sample(2).each do |department|
    user.departments << department
  end
end

# create salaries
usersId.each do |id|
  12.times do
    salary = Salary.create!(
      user_id: id,
      amount: Faker::Number.number(digits: 6),
      date: Faker::Date.between(from: '2014-09-23', to: '2023-04-25'),
      organization_id: orgIds[0]
    )
    salary.save!
  end
end

# create activities
base_date = DateTime.now
day_hours = [[8, 13, 15, 18], [8.5, 14, 15, 19], [7.5, 12.5, 13.5, 19]]
user = User.find_by(role: :admin)

day_hours.each_with_index do |hours, index|
  date = base_date + index.days
  # Create assistances
  hours.each_with_index do |hour, hour_index|
    Assistance.create!(
      user: user,
      happened_at: date.beginning_of_day + hour.hours,
      kind: hour_index.even? ? 'in' : 'out'
    )
  end

  # Register anomalities
  RegisterActivities.for(user: user, day: date)
end

