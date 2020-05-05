# frozen_string_literal: true

require 'rails_helper'

describe Batch, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:data) }
  end
end
