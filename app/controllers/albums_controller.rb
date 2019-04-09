class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :update, :destroy]
  
  def index
    @albums = Album.all
    json_response(@albums)
  end

  def create
    if album_source_exists
      json_response({ message: "This album already exists!" }, :conflict)
    else 
      @album = Album.create!(album_params)
      json_response({:album => @album, :artists => @album.artists}, :created)
    end
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
    params.require(:album).permit(
      :name, :added_at, :release_date, :height, :width, :img_url, :total_tracks, 
      artists_attributes: [:id, :name, :img_url],
      album_sources_attributes: [:source, :source_id]
    ) 
  end

  def set_album
    @album = Album.find(params[:id])
  end

  # TODO add tests
  # TODO check if best way to do this
  def album_source_exists
    params.require(:album).require(:album_sources_attributes).each do |source|
      return true if AlbumSource.exists?(source_id: source[:source_id], source: source[:source])
    end
    false
  end
end

