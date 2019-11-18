class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]

  def index
    @albums = Album.all
  end

  def show; end

  def create
    if !params.has_key?(:artists)
      render json: {status: "error", code: 4000, message: "artists should not be blank"}, status: :bad_request
      return
    end

    begin
      ActiveRecord::Base.transaction do
        @album = Album.new(album_params)
        @album.save!

        # Handle artists
        artist_params[:artists].each do |artist|
          ActiveRecord::Base.transaction do
            @artist = create_or_update_artist(artist) 
            @album.artists << @artist
          end
        end

        # Handle genres
        if params.has_key?(:genres)
          genre_params[:genres].each do |genre|
            ActiveRecord::Base.transaction do
              @genre = create_or_get_genre(genre) 
              @album.genres << @genre
            end
          end 
        end

        render :show, status: :created
      end
    rescue ActiveRecord::RecordInvalid => exception
      render json: {status: "error", code: 4000, message: exception}, status: :bad_request
    end
  end

  def update
    if @album.update(album_params)
      render :show, status: :ok
    else
      render json: {status: "error", code: 4000, message: "Could not update album"}, status: :bad_request
    end
  end
  
  def destroy
    @album.destroy
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.permit(:name, :release_date, :added_at, :total_tracks, :img_url, :img_width, 
      :img_height, :spotify_id, :discogs_id)
  end

  def artist_params
    params.permit(:artists => [:name, :img_url, :spotify_id, :discogs_id])
  end

  def genre_params
    params.permit(:genres => [:name])
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

  def create_or_update_artist(artist_params) 
    artist_ids = artist_ids(artist_params)

    if Artist.exists?(artist_ids)
      artist = Artist.find_by(artist_ids)
      artist.update(artist_params)
      return artist
    end

    Artist.create!(artist_params)
  end

  def create_or_get_genre(genre_params) 
    puts "_________________"
    pp genre_params
    if Genre.exists?(genre_params)
      genre = Genre.find_by(genre_params)
      pp genre
      return genre
    end

    Genre.create!(genre_params)
  end
end
