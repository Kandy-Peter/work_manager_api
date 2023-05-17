dep_ids = ['025bb566-5fb5-48f5-77d1-593289f31124', '025bb566-5fb5-48f5-77d1-593289f31125', '025bb566-5fb5-48f5-77d1-593289f31126']

5.times do
  position = Position.create!(name: Faker::Job.title, department_id: dep_ids[0])
  position.save!
end

5.times do
  position = Position.create!(name: Faker::Job.title, department_id: dep_ids[1])
  position.save!
end

5.times do
  position = Position.create!(name: Faker::Job.title, department_id: dep_ids[2])
  position.save!
end

