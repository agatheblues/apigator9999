FactoryBot.define do
  sequence :album_name do |n|
    "album_#{n}"
  end

  factory :album do
    added_at { "Sun, 17 Feb 2019 20:56:11 GMT" }
    name { generate(:album_name) }
    release_date { 2018 }
    img_url { "http://placekitten.com/400/400" }
    total_tracks { 15 }
    height { 400 }
    width { 400 }
    spotify_id { generate(:spotify_id) }
    discogs_id { generate(:discogs_id) }
    artists { |a| [a.association(:artist)] }
  end
end
