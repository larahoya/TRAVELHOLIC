require 'faker'

FactoryGirl.define do

  factory :traveler do |f|
    f.first_name {Faker::Name.first_name}
    f.last_name {Faker::Name.last_name}
    f.country {Faker::Address.country}
    f.date_of_birth {Faker::Date.backward(10)}
    f.gender 'FEMALE'
    f.avatar {Faker::Avatar.image}
  end

end