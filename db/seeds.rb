require 'faker'

10.times do
  title = [Faker::Lorem.sentence(3, true, 4)].sample
  description = [Faker::Lorem.paragraph].sample
  initial_date = Date.today
  final_date = [Faker::Date.forward(20)].sample
  countries = [Faker::Lorem.sentence].sample
  places = [Faker::Lorem.sentence].sample
  budget = 'low'
  requirements = [Faker::Lorem.sentence].sample
  maximum_people = 10
  people = 2

  Travel.create(title: title, description: description, initial_date: initial_date, final_date: final_date, countries: countries, places: places, budget: budget, requirements: requirements, maximum_people: maximum_people, people: people)
end