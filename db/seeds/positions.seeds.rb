5.times do
  position = Position.create!(name: Faker::Job.title, department_id: 1)
  position.save!
end

4.times do
  position = Position.create!(name: Faker::Job.title, department_id: 2)
  position.save!
end

3.times do
  position = Position.create!(name: Faker::Job.title, department_id: 3)
  position.save!
end

2.times do
  position = Position.create!(name: Faker::Job.title, department_id: 4)
  position.save!
end