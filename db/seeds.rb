require 'faker'

User.create(
  first_name: 'Lara', 
  last_name: 'Hoya Trujillo', 
  address: 'Camarena 71', 
  city: 'Madrid', 
  country: 'Spain', 
  date_of_birth: Date.new(1985,1,1), 
  email: 'lara@gmail.com', 
  telephone: '911234567', 
  password: '12345678', 
  password_confirmation: '12345678', 
  gender: 'FEMALE', 
  avatar: '/assets/avatar2.jpg')

User.create(
  first_name: 'Alex', 
  last_name: 'Hoya Trujillo', 
  address: 'Camarena 71', 
  city: 'Madrid', 
  country: 'Spain', 
  date_of_birth: Date.new(1987,1,1), 
  email: 'alex@gmail.com', 
  telephone: '911234567', 
  password: '12345678', 
  password_confirmation: '12345678', 
  gender: 'FEMALE', 
  avatar: '/assets/avatar4.jpg')

User.create(
  first_name: 'Rober', 
  last_name: 'Gonzalez', 
  address: 'Valmojado 71', 
  city: 'Madrid', 
  country: 'Spain', 
  date_of_birth: Date.new(1988,1,1), 
  email: 'rober@gmail.com', 
  telephone: '911234567', 
  password: '12345678', 
  password_confirmation: '12345678', 
  gender: 'MALE', 
  avatar: '/assets/avatar1.jpg')

Travel.create(
  user_id: 0, 
  title: 'Greece Tour', 
  description: 'A great tour throught the ancient architecture!!', 
  initial_date: Date.new(2015,7,7), 
  final_date: Date.new(2015,8,8), 
  budget: 'high', 
  maximum_people: 10, 
  people: 1)

Travel.create(
  user_id: 0, 
  title: 'Crazy weekend!', 
  description: 'A only woman travel to enjoy a crazy weekend!', 
  initial_date: Date.new(2015,7,7), 
  final_date: Date.new(2015,8,8), 
  budget: 'low', 
  maximum_people: 20, 
  people: 1)

Travel.create(
  user_id: 1, 
  title: 'New York, New York!', 
  description: 'We want to stay in the city for one month to enjoy it! We are looking for young people from all the countries to join us in this experience.', 
  initial_date: Date.new(2015,6,6), 
  final_date: Date.new(2015,7,7), 
  budget: 'high', 
  maximum_people: 30, 
  people: 1)

Travel.create(
  user_id: 1, 
  title: 'Madrid', 
  description: 'I am going to stay all the christmas in Madrid for job and I want to know people who are going to be there.', 
  initial_date: Date.new(2015,12,12), 
  final_date: Date.new(2015,12,31), 
  budget: 'medium', 
  maximum_people: 6, 
  people: 1)

Travel.create(
  user_id: 2, 
  title: 'Surf summer!!!', 
  description: 'Me and my friends are going to stay a week in the north of Spain doing a surf course. Do you want to join us?', 
  initial_date: Date.new(2015,7,7), 
  final_date: Date.new(2015,8,8), 
  budget: 'low', 
  maximum_people: 12, 
  people: 1)

Travel.create(
  user_id: 2, 
  title: 'South America Backpacking Month', 
  description: 'I´m going to travel throught south America during six months and I want to know people from all the places where I´m gonna be.', 
  initial_date: Date.new(2015,7,7), 
  final_date: Date.new(2015,11,1), 
  budget: 'low', 
  maximum_people: 20, 
  people: 1)

(0..15).each do |index|
  Comment.create(
    user_id: rand(3), 
    travel_id: rand(6), 
    name: [Faker::Name.first_name].sample, 
    description: [Faker::Lorem.paragraph].sample, 
    category: true)
end

(0..15).each do |index|
  Comment.create(
    user_id: rand(3), 
    travel_id: rand(6), 
    name: [Faker::Name.first_name].sample, 
    description: [Faker::Lorem.paragraph].sample, 
    category: false)
end


# (0..10).each do |index|
#   first_name = [Faker::Name.first_name].sample
#   last_name = [Faker::Name.last_name].sample
#   address = [Faker::Address.street_address].sample
#   city = [Faker::Address.city].sample
#   country = [Faker::Address.country].sample
#   date_of_birth = [Faker::Date.backward(10)].sample
#   email = [Faker::Internet.email].sample
#   telephone = [Faker::Number.number(4)].sample
#   password = '12345678'
#   password_confirmation = '12345678'
#   avatar = '/assets/avatar1.jpg'
#   gender = 'FEMALE'

#   User.create(first_name: first_name, last_name: last_name, address: address, city: city, country: country, date_of_birth:date_of_birth, email: email, telephone: telephone, password: password, password_confirmation: password_confirmation, gender: gender, avatar: avatar)

#   title1 = [Faker::Lorem.sentence(3, true, 4)].sample
#   title2 = [Faker::Lorem.sentence(3, true, 4)].sample
#   description = [Faker::Lorem.paragraph].sample
#   initial_date = Date.today
#   final_date = [Faker::Date.forward(20)].sample
#   budget = 'low'
#   maximum_people = 10

#   Travel.create(user_id: index, title: title1, description: description, initial_date: initial_date, final_date: final_date, budget: budget, maximum_people: maximum_people, people: 1)
#   Travel.create(user_id: index, title: title2, description: description, initial_date: initial_date, final_date: final_date, budget: budget, maximum_people: maximum_people, people: 1)
#   Travel.create(user_id: index, title: title2, description: description, initial_date: initial_date, final_date: final_date, budget: budget, maximum_people: maximum_people, people: 1)

#   Traveler.create(user_id:index, first_name: first_name, last_name: last_name, country: country, date_of_birth: date_of_birth, gender: 'FEMALE', avatar: '/assets/avatar1.jpg')
#   Traveler.create(user_id:index, first_name: first_name, last_name: last_name, country: country, date_of_birth: date_of_birth, gender: 'FEMALE', avatar: '/assets/avatar1.jpg')
# end

# (0..10).each do |index|
#   name = [Faker::Name.first_name].sample
#   description = [Faker::Lorem.paragraph].sample
#   Comment.create(user_id: rand(10), travel_id: rand(20), name: name, description: description, category: true)
# end

# (0..10).each do |index|
#   name = [Faker::Name.first_name].sample
#   description = [Faker::Lorem.paragraph].sample
#   Comment.create(user_id: rand(10), travel_id: rand(20), name: name, description: description, category: false)
# end