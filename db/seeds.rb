require 'faker'

(0..10).each do |index|
  first_name = [Faker::Name.first_name].sample
  last_name = [Faker::Name.last_name].sample
  address = [Faker::Address.street_address].sample
  city = [Faker::Address.city].sample
  country = [Faker::Address.country].sample
  date_of_birth = [Faker::Date.backward(10)].sample
  email = [Faker::Internet.email].sample
  telephone = [Faker::Number.number(4)].sample
  password = '12345678'
  password_confirmation = '12345678'

  User.create(first_name: first_name, last_name: last_name, address: address, city: city, country: country, date_of_birth:date_of_birth, email: email, telephone: telephone, password: password, password_confirmation: password_confirmation)

  title1 = [Faker::Lorem.sentence(3, true, 4)].sample
  title2 = [Faker::Lorem.sentence(3, true, 4)].sample
  description = [Faker::Lorem.paragraph].sample
  initial_date = Date.today
  final_date = [Faker::Date.forward(20)].sample
  budget = 'low'
  maximum_people = 10

  Travel.create(user_id: index, title: title1, description: description, initial_date: initial_date, final_date: final_date, budget: budget, maximum_people: maximum_people, people: 1)
  Travel.create(user_id: index, title: title2, description: description, initial_date: initial_date, final_date: final_date, budget: budget, maximum_people: maximum_people, people: 1)

end