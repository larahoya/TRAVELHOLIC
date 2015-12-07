require 'faker'

FactoryGirl.define do
  factory :travel do |f|
    f.title {Faker::Lorem.word}
    f.description {Faker::Lorem.paragraph}
    f.initial_date Date.today
    f.final_date {Faker::Date.forward(20)}
    f.budget 'low'
    f.maximum_people 10
    f.people 2
    f.tag_list ['Adventure']
    f.place_list ['Madrid']
    f.country_list ['Spain']
    f.requirement_list ['Only people without children']
  end

end