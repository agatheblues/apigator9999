json.artists @artists.each do |artist|
  json.id artist.id
  json.name artist.name
  json.spotify_id artist.spotify_id
  json.discogs_id artist.discogs_id
  json.img_url artist.img_url
end