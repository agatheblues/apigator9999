DatabaseCleaner.clean_with :truncation

artist_0 = Artist.create({
  name: 'artist_0', 
  img_url: 'http://placekitten.com/300/300',
  discogs_id: '253966',
})

artist_1 = Artist.create({
  name: 'artist_1', 
  img_url: 'http://placekitten.com/300/300',
  spotify_id: '7oqXnxR9Xg9Okhs17asfwe8S',
})

albums = Album.create([
  {
    name: 'album_0',
    added_at: 'Feb, 25 2015',
    release_date: 'June 2018',
    total_tracks: 7,
    height: 200,
    width: 200,
    img_url: 'http://placekitten.com/400/400',
    discogs_id: '1443345',
    artists: [ artist_0 ]
  },
  {
    name: 'album_1',
    added_at: 'May, 25 2015',
    release_date: 'June 2018',
    total_tracks: 10,
    height: 200,
    width: 200,
    img_url: 'http://placekitten.com/400/400',
    discogs_id: '987762',
    spotify_id: '2H5yYiN7sNAsxoZIg83yiD',
    artists: [ artist_0, artist_1 ]
  }
])
