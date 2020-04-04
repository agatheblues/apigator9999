# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilterAlbums do
  subject(:call) { service.call }
  let(:service) { described_class.new(relation, params) }

  let(:albums) { FactoryBot.create_list(:album, 10) }
  let(:relation) { Album.all.includes(:artists, :genres, :styles) }

  before { albums }

  context 'when no filters are applied' do
    let(:params) { {} }

    it 'returns the entire set' do
      expect(call).to eq(relation)
    end
  end

  context 'when one genre filter is applied' do
    let(:album) { Album.first }
    let(:genre_id) { album.genres.first.id }
    let(:params) { { 'genres' => genre_id.to_s } }

    it 'returns a filtered list' do
      expect(call).to eq([album])
    end
  end

  context 'when many genre filters are applied' do
    let(:album_1) { Album.first }
    let(:album_2) { Album.second }
    let(:genre_1) { album_1.genres.first.id }
    let(:genre_2) { album_2.genres.first.id }
    let(:params) { { 'genres' => "#{genre_1},#{genre_2}" } }

    it 'returns a filtered list' do
      expect(call.order('albums.added_at')).to eq([album_2, album_1].sort_by(&:added_at))
    end
  end

  context 'when one style filter is applied' do
    let(:album) { Album.first }
    let(:style_id) { album.styles.first.id }
    let(:params) { { 'styles' => style_id.to_s } }

    it 'returns a filtered list' do
      expect(call).to eq([album])
    end
  end

  context 'when many style filters are applied' do
    let(:album_1) { Album.first }
    let(:album_2) { Album.second }
    let(:style_1) { album_1.styles.first.id }
    let(:style_2) { album_2.styles.first.id }
    let(:params) { { 'styles' => "#{style_1},#{style_2}" } }

    it 'returns a filtered list' do
      expect(call.order('albums.added_at')).to eq([album_1, album_2].sort_by(&:added_at))
    end
  end

  context 'when a genre and a style filters are applied' do
    let(:album_1) { Album.first }
    let(:genre) { album_1.genres.first }
    let(:style) { album_1.styles.first }
    let(:attrs) { FactoryBot.attributes_for(:album).merge('genres' => [genre], 'styles' => [style]) }
    let(:album_2) { Album.create(attrs) }
    let(:params) { { 'styles' => style.id.to_s, 'genres' => genre.id.to_s } }

    before do
      Album.create(FactoryBot.attributes_for(:album).merge('genres' => [genre]))
      Album.create(FactoryBot.attributes_for(:album).merge('styles' => [style]))
    end

    it 'only returns albums that match both params' do
      expect(call.order('albums.added_at')).to eq([album_1, album_2].sort_by(&:added_at))
    end
  end
end
