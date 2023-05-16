
# create departments
5.times do
  department = Department.create!(
    name: Faker::Company.industry,
    description: Faker::Company.bs,
    organization_id: 1
  )
  department.save!
end