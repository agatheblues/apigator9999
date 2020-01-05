require_relative 'firebase_dump'

def get_total_tracks(album_id)
  artist_id = $artists.keys.find do |id|
    $artists.dig(id, :albums).has_key?(album_id)
  end
  
  $artists.dig(artist_id, :albums, album_id, :totalTracks)
end

def create_or_set_genre(genre) 
  existing_genre = Genre.find_by({name: genre})

  if !existing_genre.nil?
    return existing_genre
  else
    return Genre.create!({ name: genre })
  end
end

def create_or_set_style(style) 
  existing_style = Style.find_by({name: style})

  if !existing_style.nil?
    return existing_style
  else
    return Style.create!({ name: style })
  end
end

album_firebase_to_sql_id = {}

puts "Destroy all records in Artist, Album, Genre, Style..."

Artist.all.map(&:destroy)
Album.all.map(&:destroy)
Genre.all.map(&:destroy)
Style.all.map(&:destroy)

puts "Creating albums..."

$albums.keys.each do |id|
  genres = $albums.dig(id, :genres).nil? ? [] : $albums.dig(id, :genres).map { |genre| create_or_set_genre(genre) }
  styles = $albums.dig(id, :styles).nil? ? [] : $albums.dig(id, :styles).map { |style| create_or_set_style(style) }
  total_tracks = get_total_tracks(id)

  album = Album.create({
    added_at: $albums.dig(id, :added_at),
    name: $albums.dig(id, :name),
    release_date: $albums.dig(id, :release_date),
    spotify_id: $albums.dig(id, :sources, :spotify),
    discogs_id: $albums.dig(id, :sources, :discogs),
    img_url: $albums.dig(id, :images, :imgUrl),
    img_height: $albums.dig(id, :images, :height),
    img_width: $albums.dig(id, :images, :width),
    total_tracks: total_tracks,
    genres: genres,
    styles: styles
  })

  album_firebase_to_sql_id[id] = album['id']
end

puts "Creating artists..."

$artists.keys.each do |id|
  total_albums = $artists.dig(id, :albums).keys.length()
  total_tracks = $artists.dig(id, :albums).keys.reduce(0) { |acc, key| acc + $artists.dig(id, :albums, key, :totalTracks) }

  artist = Artist.create({
    name: $artists.dig(id, :name),
    img_url: $artists.dig(id, :imgUrl),
    spotify_id: $artists.dig(id, :sources, :spotify),
    discogs_id:  $artists.dig(id, :sources, :discogs),
    total_albums: total_albums,
    total_tracks: total_tracks
  })

  inserts = []

  $artists.dig(id, :albums).keys.each do |firebase_album_id|
    album_id = album_firebase_to_sql_id.fetch(firebase_album_id)
    inserts.push "(#{artist['id']}, #{album_id})"
  end

  sql = "INSERT INTO albums_artists (artist_id, album_id) VALUES #{inserts.join(", ")}"
  ActiveRecord::Base.connection.execute(sql)
end

