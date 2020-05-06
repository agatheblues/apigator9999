# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateAlbumsWorker, type: :job do
  subject(:perform) { worker.perform(batch.id) }
  let(:worker) { described_class.new }
  let(:albums) do
    [
      attributes_for_album,
      attributes_for_album
    ]
  end
  let(:batch) { FactoryBot.create(:batch, data: albums) }
  let(:create_album) { instance_double(CreateAlbum) }

  context 'with valid batch' do
    it 'creates the albums' do
      expect(CreateAlbum).to receive(:new).and_return(create_album).exactly(2).times
      expect(create_album).to receive(:call).exactly(2).times
      perform
    end
  end

  context 'with non-unique albums' do
    it 'creates the albums without raising' do
      expect(CreateAlbum).to receive(:new).and_return(create_album).exactly(2).times
      expect(create_album).to receive(:call).exactly(2).times.and_raise(ActiveRecord::RecordNotUnique)
      perform
    end
  end

  private

  def attributes_for_album
    FactoryBot.attributes_for(:album).merge(
      {
        artists: FactoryBot.attributes_for_list(:artist, 2),
        genres: FactoryBot.attributes_for_list(:genre, 2),
        styles: FactoryBot.attributes_for_list(:style, 2)
      }
    )
  end
end
