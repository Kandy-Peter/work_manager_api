# Create super admin
super_admin = User.find_or_initialize_by(email: ENV['SUPER_ADMIN_EMAIL'])
super_admin.password = ENV['SUPER_ADMIN_PASSWORD']
super_admin.first_name = ENV['SUPER_ADMIN_FIRST_NAME']
super_admin.last_name = ENV['SUPER_ADMIN_LAST_NAME']
super_admin.username = ENV['SUPER_ADMIN_USERNAME']
super_admin.is_admin = true
super_admin.role = :super_admin
super_admin.save!

# Create admin
admin = User.find_or_initialize_by(email: 'monroe@example.com')
admin.password = '12345kp8M'
admin.first_name = 'Monroe'
admin.last_name = 'Parker'
admin.username = 'monroe'
admin.is_admin = true
admin.role = :admin
admin.organization_id = 1
admin.save!

# create manager
manager = User.find_or_initialize_by(email: 'guymopa@example.com')
manager.password = '12345kp8M'
manager.first_name = 'Guy'
manager.last_name = 'Mopa'
manager.username = 'guymopa'
manager.is_admin = true
manager.role = :manager
manager.organization_id = 1
manager.save!

# Create employee
employee = User.find_or_initialize_by(email: 'roland@example.com')
employee.password = '12345kp8M'
employee.role = :employee
employee.first_name = 'Roland'
employee.last_name = 'Mopa'
employee.username = 'roland'
employee.organization_id = 1
employee.save!

# create other employees with faker
10.times do
  employee = User.find_or_initialize_by(email: Faker::Internet.email)
  employee.password = '12345kp8M'
  employee.role = :employee
  employee.first_name = Faker::Name.first_name
  employee.last_name = Faker::Name.last_name
  employee.username = Faker::Internet.username
  employee.organization_id = 1
  employee.save!
end