# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create super admin
super_admin = User.find_or_initialize_by(email: ENV['SUPER_ADMIN_EMAIL'])
super_admin.password = ENV['SUPER_ADMIN_PASSWORD']
super_admin.first_name = ENV['SUPER_ADMIN_FIRST_NAME']
super_admin.last_name = ENV['SUPER_ADMIN_LAST_NAME']
super_admin.username = ENV['SUPER_ADMIN_USERNAME']
super_admin.is_admin = true
super_admin.positions << Position.create!(name: "CEO")
super_admin.positions << Position.create!(name: "HR")
super_admin.role = :super_admin
super_admin.save!
