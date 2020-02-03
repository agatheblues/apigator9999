require 'rails_helper'

RSpec.describe CreateOrUpdateArtists do
  subject(:call) { service.call }
  let(:service) { described_class.new(artists, total_tracks) }
  let(:total_tracks) { 10 }

  context 'when artist is new' do
    let(:artists) { 
      [
        {
          'name' => "Artist 1",
          'img_url' => "https://placekitten.com/200/300",
          'discogs_id' => "discogs_1"
        } 
      ]
    }

    it 'creates a new artist' do
      expect { call }.to change(Artist, :count).by(1)
      expect(Artist.last.total_albums).to eq(1)
      expect(Artist.last.total_tracks).to eq(10)
    end
  end

  context 'when artist already exists' do
    context 'and is a spotify artist' do
      let(:artist) { FactoryBot.create(:artist, spotify_id: 'lumps', total_albums: 2, total_tracks: 5)}
      let(:artists) { 
        [
          {
            'name' => "Artist 1",
            'img_url' => "https://placekitten.com/200/300",
            'spotify_id' => 'lumps'
          } 
        ]
      }

      before { artist }

      it 'updates the artist' do
        expect { call }.not_to change(Artist, :count)
        artist.reload
        expect(artist.total_albums).to eq(3)
        expect(artist.total_tracks).to eq(15)
      end
    end

    context 'and is a discogs artist' do
      let(:artist) { FactoryBot.create(:artist, discogs_id: 'lumps', total_albums: 2, total_tracks: 5)}
      let(:artists) { 
        [
          {
            'name' => "Artist 1",
            'img_url' => "https://placekitten.com/200/300",
            'discogs_id' => 'lumps'
          } 
        ]
      }

      before { artist }
      
      it 'updates the artist' do
        expect { call }.not_to change(Artist, :count)
        artist.reload
        expect(artist.total_albums).to eq(3)
        expect(artist.total_tracks).to eq(15)
      end
    end

    context 'and is both a discogs and spotify artist' do
      let(:artist) { FactoryBot.create(:artist, discogs_id: 'lumps', spotify_id: 'chump', total_albums: 2, total_tracks: 5)}
      let(:artists) { 
        [
          {
            'name' => "Artist 1",
            'img_url' => "https://placekitten.com/200/300",
            'discogs_id' => 'lumps',
            'spotify_id' => 'chump'
          } 
        ]
      }

      before { artist }
      
      it 'updates the artist' do
        expect { call }.not_to change(Artist, :count)
        artist.reload
        expect(artist.total_albums).to eq(3)
        expect(artist.total_tracks).to eq(15)
      end
    end
  end
end