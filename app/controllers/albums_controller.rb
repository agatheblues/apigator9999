class AlbumsController < ApplicationController
  include FilterAlbums
  include CreateAlbumsAssociations
  before_action :set_album, only: [:show, :update, :destroy]

  def index
    @albums = filter(Album.all)
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

        # Handle genres
        if params.has_key?(:genres)
          genre_params[:genres].each do |genre|
            ActiveRecord::Base.transaction do
              @genre = create_or_get_genre(genre) 
              @album.genres << @genre[:genre]
            end
          end 
        end

        # Handle styles
        if params.has_key?(:styles)
          style_params[:styles].each do |style|
            ActiveRecord::Base.transaction do
              @style = create_or_get_style(style) 
              @album.styles << @style[:style]
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
    begin
      ActiveRecord::Base.transaction do
        @album.update(album_params)

        handle_artists(artist_params['artists'], album_params['total_tracks'].to_i, true) if params.has_key?(:artists)

        # Handle genres
        if params.has_key?(:genres)
          genre_params[:genres].each do |genre|
            ActiveRecord::Base.transaction do
              @genre = create_or_get_genre(genre) 
              @album.genres << @genre[:genre] if @genre[:new]
            end
          end 
        end

        # Handle styles
        if params.has_key?(:styles)
          style_params[:styles].each do |style|
            ActiveRecord::Base.transaction do
              @style = create_or_get_style(style) 
              @album.styles << @style[:style] if @style[:new]
            end
          end 
        end
      
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
end
