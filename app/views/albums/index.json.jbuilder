json.albums do
  json.array! @albums, partial: 'albums/album_extended', as: :album
end
json.total_albums @total_albums
json.total_artists @total_artists