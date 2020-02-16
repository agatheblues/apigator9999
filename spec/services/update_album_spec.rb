# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateAlbum do
  subject(:call) { service.call }
  let(:service) { described_class.new(album, album_params, artists, genres, styles) }
  let(:genres) { [{ 'name' => 'dogdubs' }] }
  let(:styles) { [{ 'name' => 'dubsdog' }] }
  let(:artists) do
    [
      {
        'name' => 'Artist 1',
        'img_url' => 'https://placekitten.com/200/300',
        'discogs_id' => 'discogs_1'
      }
    ]
  end
  let(:artist) { FactoryBot.create(:artist) }
  let(:genre) { FactoryBot.create(:genre) }
  let(:style) { FactoryBot.create(:style) }
  let(:album) { FactoryBot.create(:album) }
  let(:create_or_update_genres) { instance_double(CreateOrUpdateGenres) }
  let(:create_or_update_styles) { instance_double(CreateOrUpdateStyles) }
  let(:create_or_update_artists) { instance_double(CreateOrUpdateArtists) }

  before { album }

  context 'when attributes are valid' do
    let(:album_params) do
      {
        'name' => 'Pickles',
        'added_at' => Time.zone.now,
        'release_date' => '2016-01-01',
        'total_tracks' => 12,
        'img_url' => 'https://placekitten.com/200/300',
        'img_width' => 200,
        'img_height' => 300,
        'spotify_id' => 'spotify_pickle',
        'discogs_id' => 'discogs_pickle'
      }
    end

    it 'updates the album and call the right services' do
      expect(CreateOrUpdateGenres).to receive(:new).with(genres)
                                                   .and_return(create_or_update_genres)
      expect(create_or_update_genres).to receive(:call).and_return([genre])

      expect(CreateOrUpdateStyles).to receive(:new).with(styles)
                                                   .and_return(create_or_update_styles)
      expect(create_or_update_styles).to receive(:call).and_return([style])

      expect(CreateOrUpdateArtists).to receive(:new).with(artists, album_params['total_tracks'])
                                                    .and_return(create_or_update_artists)
      expect(create_or_update_artists).to receive(:call).and_return([artist])

      expect { call }.not_to change(Album, :count)
      expect(album.reload).to have_attributes(album_params)
    end
  end

  context 'when no artists, genres or styles are passed' do
    let(:album_params) { { 'name': 'another name' } }

    it 'updates the album only and does not update the artists, genres or styles' do
      expect { call }.not_to change(Album, :count)
      expect(album.reload).to have_attributes(album_params)
    end
  end
end
