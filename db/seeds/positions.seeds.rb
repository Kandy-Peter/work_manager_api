5.times do
  position = Position.create!(name: Faker::Job.title, organization_id: 1)
  position.save!
end