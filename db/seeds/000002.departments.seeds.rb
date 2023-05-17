
# create departments

department = Department.create!(
  id: '025bb566-5fb5-48f5-77d1-593289f31124',
  name: Faker::Company.industry,
  description: Faker::Company.bs,
  organization_id: '025bb566-5fb5-48f5-89d1-593289f31124'
)
department.save!

department = Department.create!(
  id: '025bb566-5fb5-48f5-77d1-593289f31125',
  name: Faker::Company.industry,
  description: Faker::Company.bs,
  organization_id: '025bb566-5fb5-48f5-89d1-593289f31124'
)
department.save!

department = Department.create!(
  id: '025bb566-5fb5-48f5-77d1-593289f31126',
  name: Faker::Company.industry,
  description: Faker::Company.bs,
  organization_id: '4f485151-bd1c-4b27-8d5e-3924f550b674'
)
department.save!


