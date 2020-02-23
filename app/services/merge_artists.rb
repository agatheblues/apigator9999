# frozen_string_literal: true

class MergeArtists
  def self.call(*args)
    new(*args).call
  end

  def call
    ids = [@artist1, @artist2].map(&method(:artist_ids))
    raise ArtistsMergeInvalidError if invalid?(ids)

    ActiveRecord::Base.transaction do
      attrs = merge_attrs(ids)
      @artist1.albums << @artist2.albums
      @artist2.destroy
      @artist1.update(attrs)
      @artist1
    end
  end

  private

  def initialize(artist1, artist2)
    @artist1 = artist1
    @artist2 = artist2
  end

  def artist_ids(artist)
    {
      spotify_id: artist['spotify_id'],
      discogs_id: artist['discogs_id']
    }.compact
  end

  def invalid?(ids)
    ids.all? { |id| id.key?(:discogs_id) } || ids.all? { |id| id.key?(:spotify_id) }
  end

  def merge_attrs(ids)
    attrs = ids.inject({}) { |acc, id| acc.merge(id) }
    attrs['total_albums'] = @artist1.total_albums + @artist2.total_albums
    attrs['total_tracks'] = @artist1.total_tracks + @artist2.total_tracks
    attrs
  end

  class ArtistsMergeInvalidError < StandardError
    def message
      'two mergeable artists can only have one source id each'
    end
  end
end
