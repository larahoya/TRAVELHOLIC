FactoryGirl.define do
  factory :user do |f|

    f.first_name {Faker::Name.first_name}
    f.last_name {Faker::Name.last_name}
    f.address {Faker::Address.street_address}
    f.city {Faker::Address.city}
    f.country {Faker::Address.country}
    f.date_of_birth {Faker::Date.backward(10)}
    f.telephone {Faker::Number.number(4)}
    f.email {Faker::Internet.email}
    f.password '12345678'
    f.password_confirmation '12345678'
    f.gender 'FEMALE'
    f.avatar '/assets/avatar1.jpg'
  end

end
