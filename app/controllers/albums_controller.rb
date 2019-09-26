class AlbumsController < ApplicationController
  before_action :set_album, only: [:show]

  def index
    @albums = Album.all
  end

  def show; end

  def create
    @album = Album.new(album_params)
    if @album.save
      render :show, status: :created
    end
  end

  private

  def set_album
    @album = Album.find(params[:id])
  end

  def album_params
    params.require(:album).permit(
      :name, :release_date, :added_at, :total_tracks, :img_url, :img_width, :img_height, :spotify_id, :discogs_id,
      artists_attributes: [:id, :name, :img_url, :spotify_id, :discogs_id]
    ) 
  end
end
