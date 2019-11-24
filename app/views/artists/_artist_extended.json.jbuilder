json.id artist.id
json.name artist.name
json.spotify_id artist.spotify_id
json.discogs_id artist.discogs_id
json.img_url artist.img_url
json.total_albums artist.total_albums
json.total_tracks artist.total_tracks
json.albums artist.albums, partial: 'albums/album_without_artists', as: :album
