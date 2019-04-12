FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

  sequence :album do |n|
    added_at { "Sun, 17 Feb 2019 20:56:11 GMT" }
    name { "album_#{n}" }
    release_date { 2018 }
    img_url { "http://placekitten.com/400/400" }
    total_tracks { 15 }
    height { 400 }
    width { 400 }
    spotify_id { "spotify_id_#{n}" }
    discogs_id { "discogs_id_#{n}" }
  end
end