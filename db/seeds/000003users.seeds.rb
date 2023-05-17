org_ids = ['025bb566-5fb5-48f5-89d1-593289f31124', '4f485151-bd1c-4b27-8d5e-3924f550b674']

users = [
  {
    email: ENV['SUPER_ADMIN_EMAIL'],
    password: ENV['SUPER_ADMIN_PASSWORD'],
    first_name: ENV['SUPER_ADMIN_FIRST_NAME'],
    last_name: ENV['SUPER_ADMIN_LAST_NAME'],
    username: ENV['SUPER_ADMIN_USERNAME'],
    is_admin: true,
    role: :super_admin
  },
  {
    email: 'monroe@example.com',
    password: '12345kp8M',
    first_name: 'Monroe',
    last_name: 'Parker',
    username: 'monroe',
    is_admin: true,
    role: :admin,
    organization_id: org_ids[0]
  },
  {
    email: 'bingo@example.com',
    password: '12345kp8M',
    first_name: 'Bingo',
    last_name: 'Parker',
    username: 'bingo',
    is_admin: true,
    role: :admin,
    organization_id: org_ids[1]
  },
  {
    email: 'guymopa@example.com',
    password: '12345kp8M',
    first_name: 'Guy',
    last_name: 'Mopa',
    username: 'guymopa',
    is_admin: true,
    role: :manager,
    organization_id: org_ids[0]
  },
  {
    email: 'johnB@example.com',
    password: '12345kp8M',
    first_name: 'John',
    last_name: 'Bingo',
    username: 'johnB',
    is_admin: true,
    role: :manager,
    organization_id: org_ids[1]
  },
]

users.each do |user_data|
  user = User.find_or_initialize_by(email: user_data[:email])
  user.assign_attributes(user_data.merge(password_confirmation: user_data[:password]))
  user.save!
end

# Create other employees with Faker
10.times do
  employee = User.find_or_initialize_by(email: Faker::Internet.email)
  employee.password = '12345kp8M'
  employee.role = :employee
  employee.first_name = Faker::Name.first_name
  employee.last_name = Faker::Name.last_name
  employee.username = Faker::Internet.username
  employee.organization_id = org_ids[0]
  employee.save!
end

5.times do
  employee = User.find_or_initialize_by(email: Faker::Internet.email)
  employee.password = '12345kp8M'
  employee.role = :employee
  employee.first_name = Faker::Name.first_name
  employee.last_name = Faker::Name.last_name
  employee.username = Faker::Internet.username
  employee.organization_id = org_ids[1]
  employee.save!
end

