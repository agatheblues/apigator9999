# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MergeArtists do
  subject(:call) { service.call }
  let(:service) { described_class.new(artist1, artist2) }

  context 'when artists are mergeable' do
    let(:albums1) { FactoryBot.create_list(:album, 2, artists_count: 0, total_tracks: 10) }
    let(:albums2) { FactoryBot.create_list(:album, 2, artists_count: 0, total_tracks: 10) }
    let(:artist1) do
      FactoryBot.create(
        :artist,
        discogs_id: nil,
        spotify_id: 'spotify_0',
        total_tracks: 20,
        total_albums: 2
      )
    end
    let(:artist2) do
      FactoryBot.create(
        :artist,
        discogs_id: 'discogs_0',
        spotify_id: nil,
        total_tracks: 20,
        total_albums: 2
      )
    end

    before do
      artist1.albums = albums1
      artist2.albums = albums2
    end

    it 'merges artist2 in artist 1' do
      attrs = artist1.attributes.merge(
        'discogs_id' => 'discogs_0',
        'total_tracks' => total_tracks(albums2, artist1['total_tracks']),
        'total_albums' => artist1['total_albums'] + albums2.length
      ).except('updated_at')

      expect { call }.to change(Artist, :count).by(-1)
      expect(artist1.reload).to have_attributes(attrs)
      expect(Artist.exists?(artist2.id)).to be false
      expect(artist1.albums).to eq(albums1.concat(albums2))
    end
  end

  context 'when artists are not mergeable' do
    context 'when artists have a discogs id' do
      let(:artist1) { FactoryBot.create(:artist, discogs_id: 'discogs_0', spotify_id: nil) }
      let(:artist2) { FactoryBot.create(:artist, discogs_id: 'discogs_1', spotify_id: nil) }

      it 'raises ArtistsMergeInvalidError' do
        expect { call }.to raise_error(MergeArtists::ArtistsMergeInvalidError)
      end
    end

    context 'when artists have a spotify id' do
      let(:artist1) { FactoryBot.create(:artist, discogs_id: nil, spotify_id: 'spotify_0') }
      let(:artist2) { FactoryBot.create(:artist, discogs_id: nil, spotify_id: 'spotify_1') }

      it 'raises ArtistsMergeInvalidError' do
        expect { call }.to raise_error(MergeArtists::ArtistsMergeInvalidError)
      end
    end
  end

  private

  def total_tracks(albums, current)
    albums.inject(current) { |acc, album| acc + album['total_tracks'] }
  end
end
