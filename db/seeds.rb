# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'date'
require 'csv'

# User.destroy_all
Rate.destroy_all
# Account.destroy_all
# Credit.destroy_all
# Payment.destroy_all

puts 'Creating data...'

# user = User.new(
#   email: 'm.calu@skynet.be',
#   password: '123456'
# )
# user.save!


filepath = "interests.csv"

CSV.foreach(filepath) do |row|
  rate = Rate.new(
    date: Date.strptime(row[0], '%d-%m-%Y'),
    date_fin: Date.strptime(row[1], '%d-%m-%Y'),
    pct: row[2],
    int_type: row[3],
    switch_date: row[4],
  )
  rate.save!
end