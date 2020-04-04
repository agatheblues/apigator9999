# frozen_string_literal: true

json.genres @genres do |genre|
  json.id genre.id
  json.name genre.name
  json.total_albums genre.total_albums
end
json.total_genres @genres.size
