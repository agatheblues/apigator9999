class CreateOrUpdateArtists
  def self.call(*args)
    new(*args).call
  end

  def call
    ActiveRecord::Base.transaction do
      @artists.map do |artist|
        existing_artist = Artist.find_by(artist_ids(artist))
        if existing_artist.nil?
          create_artist(artist) 
        else
          update_artist(existing_artist, artist)
        end
      end
    end
  end

  private

  def initialize(artists, total_tracks)
    @artists = artists
    @total_tracks = total_tracks
  end

  def get_total_albums(current_albums)
    current_albums + 1
  end

  def get_total_tracks(current_tracks)
    current_tracks + @total_tracks
  end
  
  def create_artist(attrs) 
    attrs = attrs.merge({
      'total_albums' => get_total_albums(0),
      'total_tracks' => get_total_tracks(0)
    })
    return Artist.create!(attrs)
  end

  def update_artist(existing_artist, attrs) 
    attrs = attrs.merge({
      'total_albums' => get_total_albums(existing_artist['total_albums']),
      'total_tracks' => get_total_tracks(existing_artist['total_tracks'])
    })
    existing_artist.update(attrs)
    return existing_artist
  end

  def artist_ids(artist)
    if (artist['spotify_id'].nil? && artist['discogs_id'].nil?)
      nil
    elsif (artist['spotify_id'].nil?)
      {discogs_id: artist['discogs_id']}
    elsif (artist['discogs_id'].nil?)
      {spotify_id: artist['spotify_id']}
    else
      {spotify_id: artist['spotify_id'], discogs_id: artist['discogs_id']}
    end
  end
end
