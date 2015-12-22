FactoryGirl.define do
  factory :bookmark do
    body               { Faker::Lorem.paragraph }
    bookmark_id        { Faker::Number.number(6) }
    description        { Faker::Lorem.paragraph }
    progress           0.5
    progress_timestamp { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    retrieved          { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    starred            false
    stored             false
    time               { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    title              { Faker::Lorem.sentence }
    updated_at         { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    url                { Faker::Internet.url }
  end

end