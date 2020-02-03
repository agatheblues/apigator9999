require 'rails_helper'

RSpec.describe CreateOrUpdateStyles do
  subject(:call) { service.call }
  let(:service) { described_class.new(params) }

  context 'when style is new' do
    let(:params) { [{'name' => 'dogdubs'}] }
    
    it 'creates a new style' do
      expect { call }.to change(Style, :count).by(1)
      expect(Style.last.total_albums).to eq(1)
    end
  end

  context 'when style already exists' do
    let(:style) { FactoryBot.create(:style, total_albums: 5) }
    let(:params) { [{'name' => style['name']}] }

    before { style }
    
    it 'updates the style' do
      expect { call }.not_to change(Style, :count)
      expect(style.reload.total_albums).to eq(6)
    end
  end
end