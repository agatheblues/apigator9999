module CreateAlbumsAssociations
  def handle_artists(artists, total_tracks, only_new)
    artists.each do |artist|
      ActiveRecord::Base.transaction do
        create_or_update_artist(artist, total_tracks, only_new) 
      end
    end
  end

  def handle_genres(genres, only_new)
    genres.each do |genre|
      ActiveRecord::Base.transaction do
        create_or_set_genre(genre, only_new) 
      end
    end 
  end

  def handle_styles(styles, only_new)
    styles.each do |style|
      ActiveRecord::Base.transaction do
        create_or_set_style(style, only_new) 
      end
    end 
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

  def create_or_set_genre(params, only_new) 
    existing_genre = Genre.find_by({name: params['name']})

    if !existing_genre.nil?
      @album.genres << existing_genre unless only_new
    else
      @album.genres << Genre.create!(params)
    end
  end
  
  def create_or_set_style(params, only_new) 
    existing_style = Style.find_by({name: params['name']})

    if !existing_style.nil?
      @album.styles << existing_style unless only_new
    else
      @album.styles << Style.create!(params)
    end
  end
end