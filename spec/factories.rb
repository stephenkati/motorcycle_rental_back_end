FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
  end
end

FactoryBot.define do
  factory :motorcycle do
    name { Faker::Name.name }
    photo { Faker::Internet.url }
    description { Faker::Lorem.paragraph }
    purchase_price { Faker::Number.number(digits: 4) }
    rental_price { Faker::Number.number(digits: 4) }
  end
end

FactoryBot.define do
  factory :reservation do
    city { Faker::Address.city }
    reserve_date { Faker::Date.forward(days: 23) }
    user
    motorcycle
  end
end
