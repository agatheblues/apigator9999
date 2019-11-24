json.id album.id
json.name album.name
json.img_url album.img_url
json.img_height album.img_height
json.img_width album.img_width
json.artists album.artists do |artist|
  json.id artist.id
  json.name artist.name
end
