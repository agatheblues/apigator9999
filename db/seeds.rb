# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

artists = Artist.create([
  {
    name: "Steely Dan",
    img_url: "https://placekitten.com/200/300",
    spotify_id: "art_spot_0"
  },
  {
    name: "Radiohead",
    img_url: "https://placekitten.com/200/300",
    discogs_id: "art_disc_0",
  }
])

Album.create([
  {
    added_at: "2018-01-01",
    name: "Aja",
    release_date: "1979",
    spotify_id: "spot_0",
    total_tracks: 12,
    img_url: "https://placekitten.com/200/300",
    img_height: 300,
    img_width: 200,
    artists: [artists[0]]
  },
  {
    added_at: "2017-04-01",
    name: "Ok Computer",
    release_date: "2001",
    discogs_id: "disc_0",
    total_tracks: 22,
    img_url: "https://placekitten.com/200/300",
    img_height: 300,
    img_width: 200,
    artists: [artists[1]]
  },
  {
    added_at: "2015-04-01",
    name: "Absolution",
    release_date: "1992",
    discogs_id: "disc_1",
    spotify_id: "spot_1",
    total_tracks: 14,
    img_url: "https://placekitten.com/200/300",
    img_height: 300,
    img_width: 200,
    artists: [artists[0], artists[1]]
  }
])