require 'faker'

FactoryGirl.define do
  factory :comment do |f|
    f.name {Faker::Name.first_name}
    f.travel_id {Faker::Number.number(1)}
    f.user_id {Faker::Number.number(1)}
    f.description {Faker::Lorem.paragraph}
    f.category false
  end

end