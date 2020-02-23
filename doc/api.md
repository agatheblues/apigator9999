# API

This is the list of exposed endpoints.
Artists and albums are uniquely identified, throughout the app, by the combination of their spotify and discogs id.

## Auth

### Create a user

**Method URL:** `/user`

**HTTP Method:** `POST`

**JSON Payload**: 

```
{
  "email": "coucou@example.net",
  "username": "pineapple",
  "password": "password"
}
```

### Get token

**Method URL:** `/user_token`

**HTTP Method:** `POST`

**JSON Payload**: 

```
{
  "email": "coucou@example.net",
  "password": "password"
}
```

### Get current user

**Method URL:** `/users/current`

**HTTP Method:** `GET`

**Bearer**: Token 

**Response:**

```
{
  "id": 9,
  "email": "coucou@example.net",
  "username": "pineapple",
  "role": "user"
}
```

### Update user

**Method URL:** `/users/:id`

**HTTP Method:** `PATCH`

**Bearer**: Token 

**JSON Payload**: 

```
{
  "email": "coucou@example.net",
  "username": "pineapple",
  "password": "password"
}
```

### Delete user

**Method URL:** `/users/:id`

**HTTP Method:** `DELETE`

**Bearer**: Token 

## Genres

### Get all genres

**Method URL:** `/genres`

**HTTP Method:** `GET`

**Bearer**: Token 

**Response:**

```
{
  "genres": [
    {
      "id": 73,
      "name": "Rock",
      "total_albums": 2
    },
    ...
  ],
  "total_genres": 3
}
```

## Styles

### Get all styles

**Method URL:** `/styles`

**HTTP Method:** `GET`

**Bearer**: Token 

**Response:**

```
{
  "styles": [
    {
      "id": 470,
      "name": "Rock'n'roll",
      "total_albums": 2
    },
    ...
  ],
  "total_styles": 3
}
```

## Artists

### Get all artists

**Method URL:** `/artists`

**HTTP Method:** `GET`

**Bearer**: Token 

**Response:**

```
{
  "artists": [
    {
      "id": 2288,
      "name": "Banana",
      "img_url": "https://placekitten.com/200/300",
      "total_albums": 4,
      "total_tracks": 48
    },
    ...
  ],
  "total_albums": 16,
  "total_artists": 12
}
```

### Get an artist

**Method URL:** `/artists/:id`

**HTTP Method:** `GET`

**Bearer**: Token 

**Response:**

```
{
  "id": 2288,
  "name": "Banana",
  "spotify_id": null,
  "discogs_id": "24awf8a7wf95a4sf9",
  "img_url": "https://placekitten.com/200/300",
  "total_albums": 4,
  "total_tracks": 48,
  "albums": [
    {
      "id": 3862,
      "name": "Coconut",
      "added_at": "2018-01-01T00:00:00.000Z",
      "spotify_id": null,
      "discogs_id": "aofihw57g8we7g9",
      "release_date": "1979",
      "total_tracks": 12,
      "img_url": "https://placekitten.com/200/300",
      "img_height": 300,
      "img_width": 200,
      "genres": [
        {
          "id": 73,
          "name": "Rock",
          "total_albums": 2
        }
      ],
      "styles": [
        {
          "id": 470,
          "name": "Rock'n'roll",
          "total_albums": 2
        }
      ]
    },
    ...
  ]
}
```

### Merge two artists

**Method URL:** `/artists/:id1,:id2`

**HTTP Method:** `POST`

**Bearer**: Token 

**Response:**

```
{
  "id": 2288,
  "name": "Banana",
  "spotify_id": null,
  "discogs_id": "24awf8a7wf95a4sf9",
  "img_url": "https://placekitten.com/200/300",
  "total_albums": 4,
  "total_tracks": 48,
  "albums": [
    {
      "id": 3862,
      "name": "Coconut",
      "added_at": "2018-01-01T00:00:00.000Z",
      "spotify_id": null,
      "discogs_id": "aofihw57g8we7g9",
      "release_date": "1979",
      "total_tracks": 12,
      "img_url": "https://placekitten.com/200/300",
      "img_height": 300,
      "img_width": 200,
      "genres": [
        {
          "id": 73,
          "name": "Rock",
          "total_albums": 2
        }
      ],
      "styles": [
        {
          "id": 470,
          "name": "Rock'n'roll",
          "total_albums": 2
        }
      ]
    },
    ...
  ]
}
```

## Album

### Create an album

**Method URL:** `/albums`

**HTTP Method:** `POST`

**Bearer**: Token 

**JSON Payload**: 

```
{
  "name": "Coconut",
  "added_at": "2018-01-01T00:00:00.000Z",
  "discogs_id": "aofihw57g8we7g9",          # Or spotify_id, or both
  "release_date": "1979",
  "total_tracks": 12,
  "img_url": "https://placekitten.com/200/300",
  "img_height": 300,
  "artists": [
    {
      "name": "Banana",
      "discogs_id": "24awf8a7wf95a4sf9",    # Or spotify_id, or both
      "img_url": "https://placekitten.com/200/300",
    }
  ]
  "img_width": 200,
  "genres": [
    {
      "name": "Rock"
    }
  ],
  "styles": [
    {
      "name": "Rock'n'roll"
    }
  ]
}
```

### Get all albums

**Method URL:** `/albums`

**HTTP Method:** `GET`

**Bearer**: Token 

**Query Parameters**:

- `genres=[GENRE_IDS]`
- `styles=[STYLE_IDS]`

**Response**: 

```
{
  "albums": [
    {
      "id": 3843,
      "name": "Coconut",
      "added_at": "2018-01-01T00:00:00.000Z",
      "spotify_id": null,
      "discogs_id": "aab",
      "release_date": "1979",
      "total_tracks": 12,
      "img_url": "https://placekitten.com/200/300",
      "img_height": 300,
      "img_width": 200,
      "artists": [
        {
          "id": 2287,
          "name": "Banana",
          "spotify_id": null,
          "discogs_id": "oiweur",
          "img_url": "https://placekitten.com/200/300",
          "total_albums": 4,
          "total_tracks": 48
        },
        ...
      ],
      "genres": [
        {
          "id": 73,
          "name": "Rock",
          "total_albums": 2
        },
        ...
      ],
      "styles": [
        {
          "id": 470,
          "name": "Rock'n'roll",
          "total_albums": 2
        },
        ...
      ]
    }
  ],
  "total_albums": 9,
  "total_artists": 2
}
```

### Update an album

**Method URL:** `/albums/:id`

**HTTP Method:** `PATCH`

**Bearer**: Token 

**JSON Payload**: 

```
{
  "name": "Coconut",
  "added_at": "2018-01-01T00:00:00.000Z",
  "discogs_id": "aofihw57g8we7g9",          # Or spotify_id, or both
  "release_date": "1979",
  "total_tracks": 12,
  "img_url": "https://placekitten.com/200/300",
  "img_height": 300,
  "artists": [
    {
      "name": "Banana",
      "discogs_id": "24awf8a7wf95a4sf9",    # Or spotify_id, or both
      "img_url": "https://placekitten.com/200/300",
    }
  ]
  "img_width": 200,
  "genres": [
    {
      "name": "Rock"
    }
  ],
  "styles": [
    {
      "name": "Rock'n'roll"
    }
  ]
}
```

### Delete an album

**Method URL:** `/albums/:id`

**HTTP Method:** `DELETE`

**Bearer**: Token 