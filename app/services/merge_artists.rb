# frozen_string_literal: true

class MergeArtists
  def self.call(*args)
    new(*args).call
  end

  def call
    @artist1
  end

  private

  def initialize(artist1, artist2)
    @artist1 = artist1
    @artist2 = artist2
  end
end
