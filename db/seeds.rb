# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data
Expense.delete_all
Revenue.delete_all
Session.delete_all
Service.delete_all
Client.delete_all
Trainer.delete_all
AdminUser.delete_all

# Admin Users
admin = AdminUser.create!(email: "admin@spa-cms.com", password: "password", role: "admin")
secretary = AdminUser.create!(email: "secretary@spa-cms.com", password: "password", role: "secretary")

jhonny = AdminUser.create!(email: "jhonny@spa-cms.com", password: "password", role: "trainer")
mark = AdminUser.create!(email: "mark@spa-cms.com", password: "password", role: "trainer")
# Trainers
trainer1 = Trainer.create!(first_name: "Jhonny", last_name: "Sense", phone: "01000000001", admin_user: jhonny)
trainer2 = Trainer.create!(first_name: "Mark", last_name: "Paulo", phone: "01000000002", admin_user: mark)

# Clients
5.times do |i|
  Client.create!(
    first_name: "Client#{i}",
    last_name: "Test",
    phone: "0123456789#{i}",
    email: "client#{i}@spa-cms.com"
  )
end

clients = Client.all

# Services
service1 = Service.create!(name: "Massage", price: 500.0, duration: 60)
service2 = Service.create!(name: "Facial", price: 300.0, duration: 45)

# Sessions + Revenues
10.times do
  session = Session.create!(
    client: clients.sample,
    service: [ service1, service2 ].sample,
    trainer: [ trainer1, trainer2 ].sample,
    perform_at: rand(1..5).days.from_now,
    status: Session::STATUSES.sample,
    notes: "Auto-generated test session"
  )

  Revenue.create!(session: session, amount: session.service.price)
end

5.times do
  Expense.create!(
    name: "Expense#{rand(100)}",
    amount: rand(100.0..500.0).round(2),
    occurred_on: Date.today - rand(1..30).days,
    category: Expense::CATEGORIES.sample,
    notes: "Auto-generated expense",
    trainer: [ trainer1, trainer2 ].sample
  )
end

puts "✅ Seeded successfully!"
