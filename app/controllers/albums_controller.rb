class AlbumsController < ApplicationController
  include CreateAlbumsAssociations
  
  before_action :set_album, only: [:show, :update, :destroy]

  def index
    @albums = FilterAlbums.call(Album.all, filter_params).order('added_at DESC')
    @total_albums = @albums.count
    @total_artists = @albums.map { |album| album.artists }.flatten.uniq { |artist| artist.id }.size
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
        
        handle_artists(artist_params['artists'], album_params['total_tracks'].to_i, false)
        handle_genres(genre_params['genres'], false) if params.has_key?(:genres)
        handle_styles(style_params['styles'], false) if params.has_key?(:styles)

        render :show, status: :created
      end
    rescue ActiveRecord::RecordInvalid => exception
      render json: {status: "error", code: 4000, message: exception}, status: :bad_request
    end
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @album.update(album_params)

        handle_artists(artist_params['artists'], album_params['total_tracks'].to_i, true) if params.has_key?(:artists)
        handle_genres(genre_params['genres'], true) if params.has_key?(:genres)
        handle_styles(style_params['styles'], true) if params.has_key?(:styles)
      
        render :show, status: :ok
      end
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
    params.permit(:artists => [:name, :img_url, :spotify_id, :discogs_id, :total_tracks, :total_albums])
  end

  def genre_params
    params.permit(:genres => [:name])
  end

  def style_params
    params.permit(:styles => [:name])
  end

  def filter_params
    params.permit(:genres, :styles).to_h
  end
end
