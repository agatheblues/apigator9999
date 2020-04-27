# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAlbum do
  subject(:call) { service.call }
  let(:service) { described_class.new(album_params, artists, genres, styles) }
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
  let(:create_or_update_genres) { instance_double(CreateOrUpdateGenres) }
  let(:create_or_update_styles) { instance_double(CreateOrUpdateStyles) }
  let(:create_or_update_artists) { instance_double(CreateOrUpdateArtists) }

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
        'discogs_id' => 'discogs_pickle',
        'bandcamp_url' => 'http://bandcamp.com',
        'youtube_url' => 'http://youtube.com'
      }
    end

    it 'creates the album and call the right services' do
      expect(CreateOrUpdateGenres).to receive(:new).with(genres)
                                                   .and_return(create_or_update_genres)
      expect(create_or_update_genres).to receive(:call).and_return([genre])

      expect(CreateOrUpdateStyles).to receive(:new).with(styles)
                                                   .and_return(create_or_update_styles)
      expect(create_or_update_styles).to receive(:call).and_return([style])

      expect(CreateOrUpdateArtists).to receive(:new).with(artists, album_params['total_tracks'])
                                                    .and_return(create_or_update_artists)
      expect(create_or_update_artists).to receive(:call).and_return([artist])

      expect { call }.to change(Album, :count).by(1)
      expect(Album.last).to have_attributes(album_params.except('added_at'))
    end
  end

  context 'when album attributes are not valid' do
    let(:album_params) { {} }

    it 'does not create the album and raises ActiveRecord::RecordInvalid' do
      expect { call }.to change(Album, :count).by(0).and raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when album already exists' do
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

    before { FactoryBot.create(:album, album_params) }

    it 'does not create the album and raises ActiveRecord::RecordNotUnique' do
      expect { call }.to change(Album, :count).by(0).and raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
