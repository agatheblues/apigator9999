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
json.artists album.artists, partial: 'artists/artist_without_albums', as: :artist
json.genres album.genres, partial: 'genres/genre', as: :genre
json.styles album.styles, partial: 'styles/style', as: :style
