module CreateAlbumsAssociations
  def handle_artists(artists, total_tracks, only_new)
    artists.each do |artist|
      ActiveRecord::Base.transaction do
        create_or_update_artist(artist, total_tracks, only_new) 
      end
    end
  end

  def create_or_update_artist(params, total_tracks, only_new) 
    existing_artist = Artist.find_by(artist_ids(params))

    if !existing_artist.nil?
      params = add_totals(params, existing_artist['total_tracks'], existing_artist['total_albums'], total_tracks)
      existing_artist.update(params)
      @album.artists << existing_artist unless only_new
    else
      params = add_totals(params, 0, 0, total_tracks)
      @album.artists << Artist.create!(params)
    end
  end

  def create_or_get_genre(genre_params) 
    name = {name: genre_params['name']}

    if Genre.exists?(name)
      return {new: false, genre: Genre.find_by(name)}
    end

    {new: true, genre: Genre.create!(genre_params)}
  end

  def create_or_get_style(style_params) 
    name = {name: style_params['name']}

    if Style.exists?(name)
      return {new: false, style: Style.find_by(name)}
    end

    {new: true, style: Style.create!(style_params)}
  end

  private

  def add_totals(artist_params, current_tracks, current_albums, total_tracks)
    artist_params['total_tracks'] = current_tracks + total_tracks
    artist_params['total_albums'] = current_albums + 1
    return artist_params
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