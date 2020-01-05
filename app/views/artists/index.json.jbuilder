json.artists do
  json.array! @artists, partial: 'artists/artist_short', as: :artist
end
json.total_albums @total_albums
json.total_artists @total_artists
