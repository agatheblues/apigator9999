# frozen_string_literal: true

json.albums do
  json.array! @albums, partial: 'albums/album_without_artists', as: :album
end
json.total_albums @total_albums
json.total_artists @total_artists
