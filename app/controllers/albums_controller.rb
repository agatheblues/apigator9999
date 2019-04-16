class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]
  
  def index
    @albums = Album.all
    json_response(@albums)
  end

  def create
    # if album_source_exists(params.require('album').require('spotify_id'), 'spotify')
    #   json_response({ message: "This album already exists!" }, :conflict)
    # elsif album_source_exists(params.require('album').require('discogs_id'), 'discogs')
    #   json_response({ message: "This album already exists!" }, :conflict)
    # else
    @album = Album.create!(album_params)
    json_response({:album => @album, :artists => @album.artists}, :created)
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
      :name, :added_at, :release_date, :height, :width, :img_url, :total_tracks, :spotify_id, :discogs_id,
      artists_attributes: [:id, :name, :img_url, :spotify_id, :discogs_id]
    ) 
  end

  def set_album
    @album = Album.find(params[:id])
  end

  def album_source_exists(source_id, source_name)
    AlbumSource.exists?("#{source_name}_id" => source_id)
  end
end

