require 'faker'

10.times do
  title = [Faker::Lorem.sentence(3, true, 4)].sample
  description = [Faker::Lorem.paragraph].sample
  initial_date = Date.today
  final_date = [Faker::Date.forward(20)].sample
  budget = 'low'
  maximum_people = 10

  Travel.create(title: title, description: description, initial_date: initial_date, final_date: final_date, budget: budget, maximum_people: maximum_people, people: 1)
end