# A simple script to add 10 lines of fake data to the CSV database.
# You might have to `chmod +x ./seed_csv.rb` before running.

require 'faker'
require 'csv'

CSV.open("db/database.csv", 'a') do |csv| 
  10.times do
    row = []
    row[0] = Faker::Name.last_name
    row[1] = Faker::Name.first_name 
    row[2] = ['male', 'female'].sample
    row[3] = Faker::Commerce.color
    row[4] = "#{rand(1950..2000)}-#{rand(1..12).to_s.rjust(2, '0')}-#{rand(1..30).to_s.rjust(2, '0')}"
    csv << row
  end
end




