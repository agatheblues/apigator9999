# frozen_string_literal: true

json.artists @artists do |artist|
  json.id artist.id
  json.name artist.name
  json.img_url artist.img_url
  json.spotify_id artist.spotify_id
  json.discogs_id artist.discogs_id
  json.total_albums artist.total_albums
  json.total_tracks artist.total_tracks
  json.updated_at artist.updated_at
end
json.total_albums @total_albums
json.total_artists @total_artists
