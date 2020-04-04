# frozen_string_literal: true

json.artists @artists do |artist|
  json.id artist.id
  json.name artist.name
  json.img_url artist.img_url
  json.total_albums artist.total_albums
  json.total_tracks artist.total_tracks
end
json.total_albums @total_albums
json.total_artists @total_artists
