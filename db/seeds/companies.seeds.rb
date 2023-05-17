#create organization
5.times do
  organization = Organization.create!(name: Faker::Company.name, country: Faker::Address.country, organization_type: Faker::Company.type)
  organization.save!
end
