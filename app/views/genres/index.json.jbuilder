# frozen_string_literal: true

json.genres do
  json.array! @genres, partial: 'genres/genre', as: :genre
end
json.total_genres @genres.size
