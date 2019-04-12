FactoryBot.define do
  sequence :artist do |n|
    name { "artist_#{n}" }
    img_url { "http://placekitten.com/300/300" }
    spotify_id { "spotify_id_#{n}" }
    discogs_id { "discogs_id_#{n}" }
  end
end