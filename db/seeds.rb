# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# db/seeds.rb

# Load seed files from the seeds folder
Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  load file
end

users = User.all.where(organization_id: 1)
department = Department.all.where(organization_id: 1)
usersId = User.all.where(organization_id: 1).pluck(:id)

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
      organization_id: 1
    )
    salary.save!
  end
end