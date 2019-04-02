FactoryBot.define do
  factory :album do
    added_at { Faker::Date.backward(14) }
    name { Faker::Music.album }
    release_date { Faker::Date.backward(500) }
    img_url { Faker::LoremFlickr.image }
    total_tracks { Faker::Number.number(10) }
    height { Faker::Number.number(10) }
    width { Faker::Number.number(10) }
  end
end