# frozen_string_literal: true

class CreateAlbumsWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker
  sidekiq_options retry: 5

  sidekiq_retries_exhausted do |msg, _ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform(batch_id)
    batch = Batch.find(batch_id)

    batch.data.each do |album|
      begin
        CreateAlbum.call(album_params(album), pluck(album, 'artists'), pluck(album, 'genres'), pluck(album, 'styles'))
      # rubocop:disable Lint/SuppressedException
      rescue ActiveRecord::RecordNotUnique
        # rubocop:enable Lint/SuppressedException
        # This is very specific to this endpoint, here we want to batch
        # create albums, so we want to ignore 409 and just go on.
      end
    end
  end

  private

  def album_params(album)
    album.extract!(
      'name', 'release_date', 'added_at', 'total_tracks', 'img_url', 'img_width',
      'img_height', 'spotify_id', 'discogs_id'
    )
  end

  def pluck(album, key)
    return [] unless album.key?(key)

    album[key]
  end
end
