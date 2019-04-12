FactoryBot.define do
  sequence :spotify_id do |n|
    "spotify_id_#{n}"
  end

  sequence :discogs_id do |n|
    "discogs_id_#{n}"
  end
end