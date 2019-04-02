FactoryBot.define do
  factory :artist do
    name { Faker::Music.band }
    img_url { Faker::LoremFlickr.image }
  end
end