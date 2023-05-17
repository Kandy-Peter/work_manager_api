#create organization

organization = Organization.create!(
  id:'025bb566-5fb5-48f5-89d1-593289f31124', 
  name: Faker::Company.name, 
  country: Faker::Address.country,
  organization_type: Faker::Company.type
)
organization.save!

organization2 = Organization.create!(
  id:'4f485151-bd1c-4b27-8d5e-3924f550b674', 
  name: Faker::Company.name, 
  country: Faker::Address.country, 
  organization_type: Faker::Company.type
)
organization2.save!
