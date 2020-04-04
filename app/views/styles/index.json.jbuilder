# frozen_string_literal: true

json.styles @styles do |style|
  json.id style.id
  json.name style.name
  json.total_albums style.total_albums
end
json.total_styles @styles.size
