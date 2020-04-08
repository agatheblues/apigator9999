# frozen_string_literal: true

class BatchController < ApplicationController
  def create
    raise ActiveRecord::RecordInvalid unless albums_params.key?('albums')

    ActiveRecord::Base.transaction { create_albums }

    render json: { status: 'created' }, status: :created
  rescue ActiveRecord::RecordInvalid, CreateOrUpdateArtists::ArtistsMissingError => e
    render json: { status: 'error', code: 4000, message: e.message }, status: :bad_request
  end

  private

  def create_albums
    albums_params['albums'].each do |album|
      CreateAlbum.call(album_params(album), pluck(album, 'artists'), pluck(album, 'genres'), pluck(album, 'styles'))
    end
  end

  def albums_params
    params.permit(albums: [:name, :release_date, :added_at, :total_tracks, :img_url, :img_width,
                           :img_height, :spotify_id, :discogs_id,
                           artists: %i[name img_url spotify_id discogs_id total_tracks total_albums],
                           genres: [:name],
                           styles: [:name]])
  end

  def pluck(album, key)
    return [] unless album.key?(key)

    album[key]
  end

  def album_params(album)
    album.extract!(
      :name, :release_date, :added_at, :total_tracks, :img_url, :img_width,
      :img_height, :spotify_id, :discogs_id
    )
  end
end