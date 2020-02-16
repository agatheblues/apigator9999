# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateOrUpdateGenres do
  subject(:call) { service.call }
  let(:service) { described_class.new(params) }

  context 'when genre is new' do
    let(:params) { [{ 'name' => 'dogdubs' }] }

    it 'creates a new genre' do
      expect { call }.to change(Genre, :count).by(1)
      expect(Genre.last.total_albums).to eq(1)
    end
  end

  context 'when genre already exists' do
    let(:genre) { FactoryBot.create(:genre, total_albums: 5) }
    let(:params) { [{ 'name' => genre['name'] }] }

    before { genre }

    it 'updates the genre' do
      expect { call }.not_to change(Genre, :count)
      expect(genre.reload.total_albums).to eq(6)
    end
  end
end
