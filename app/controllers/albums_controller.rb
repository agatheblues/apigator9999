class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]

  def index
    @albums = Album.all
    json_response(@albums)
  end

  def create
    @album = Album.create!(album_params)
    json_response({:album => @album, :artists => @album.artists})
  end

  def show
    json_response(@album)
  end

  def update
    @album.update(album_params)
    head :no_content
  end

  def destroy
    @album.destroy
    head :no_content
  end

  private

  def album_params
    params.permit(
      :name, :added_at, :release_date, :height, :width, :img_url, :total_tracks, 
      artists_attributes: [:id, :name, :img_url],
      album_sources_attributes: [:source, :source_id]
    ) 
  end

  def set_album
    @album = Album.find(params[:id])
  end
end

