# frozen_string_literal: true

$albums = {
  "firebase_album_id": {
    "added_at": '2018-09-16T10:56:04Z',
    "images": {
      "height": 640,
      "imgUrl": 'https://example.com',
      "width": 640
    },
    "name": 'An album',
    "release_date": '2015-11-27',
    "sources": {
      "spotify": 'spotify_id'
    },
    "url": "https://example.com"
  }
}

$artists = {
  "firebase_artist_id": {
    "albums": {
      "firebase_album_id": {
        "added_at": '2018-09-16T10:56:04Z',
        "totalTracks": 3
      }
    },
    "imgUrl": 'https://example.com',
    "name": 'An artist',
    "sources": {
      "spotify": 'artist_spotify_id'
    }
  }
}
