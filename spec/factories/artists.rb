FactoryBot.define do
  sequence :artist_name do |n|
    "artist_#{n}"
  end

  factory :artist do 
    name { generate(:artist_name) }
    img_url { "http://placekitten.com/300/300" }
    spotify_id { generate(:spotify_id) }
    discogs_id { generate(:discogs_id) }
  end
end