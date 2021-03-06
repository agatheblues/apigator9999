# frozen_string_literal: true

class CreateOrUpdateArtists
  def self.call(*args)
    new(*args).call
  end

  def call
    raise ArtistsMissingError if @artists.empty?

    ActiveRecord::Base.transaction do
      @artists.map(&method(:handle_artist))
    end
  end

  private

  def initialize(artists, total_tracks)
    @artists = artists
    @total_tracks = total_tracks
  end

  def handle_artist(artist)
    existing_artist = Artist.find_by(artist_ids(artist))

    if existing_artist.nil?
      create_artist(artist)
    else
      update_artist(existing_artist, artist)
    end
  end

  def get_total_albums(current_albums)
    current_albums + 1
  end

  def get_total_tracks(current_tracks)
    current_tracks + @total_tracks
  end

  def create_artist(attrs)
    attrs = attrs.merge(
      'total_albums' => get_total_albums(0),
      'total_tracks' => get_total_tracks(0)
    )
    Artist.create!(attrs)
  end

  def update_artist(existing_artist, attrs)
    attrs = attrs.merge(
      'total_albums' => get_total_albums(existing_artist['total_albums']),
      'total_tracks' => get_total_tracks(existing_artist['total_tracks'])
    )
    existing_artist.update(attrs)
    existing_artist
  end

  def artist_ids(artist)
    {
      spotify_id: artist['spotify_id'],
      discogs_id: artist['discogs_id']
    }.compact
  end

  class ArtistsMissingError < StandardError
    def message
      'artists should not be blank'
    end
  end
end
