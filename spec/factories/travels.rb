require 'faker'

FactoryGirl.define do
  factory :travel do |f|
    f.title {Faker::Lorem.word}
    f.description {Faker::Lorem.paragraph}
    f.initial_date Date.today
    f.final_date {Faker::Date.forward(20)}
    f.countries 'Spain,Italy'
    f.places 'Madrid,Milano'
    f.budget 'low'
    f.requirements {Faker::Lorem.sentence}
    f.maximum_people 10
    f.people 2
  end

end