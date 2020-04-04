# frozen_string_literal: true

json.id @artist.id
json.name @artist.name
json.spotify_id @artist.spotify_id
json.discogs_id @artist.discogs_id
json.img_url @artist.img_url
json.total_albums @artist.total_albums
json.total_tracks @artist.total_tracks
json.albums @artist.albums do |album|
  json.id album.id
  json.name album.name
  json.added_at album.added_at
  json.spotify_id album.spotify_id
  json.discogs_id album.discogs_id
  json.release_date album.release_date
  json.total_tracks album.total_tracks
  json.img_url album.img_url
  json.img_height album.img_height
  json.img_width album.img_width
  json.genres album.genres do |genre|
    json.id genre.id
    json.name genre.name
    json.total_albums genre.total_albums
  end
  json.styles album.styles do |style|
    json.id style.id
    json.name style.name
    json.total_albums style.total_albums
  end
end
