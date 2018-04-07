# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

User.find_or_create_by( email: 'admin@domain.org' ) do |user|
	user.password = '123456789'
  user.role = 'admin'
end