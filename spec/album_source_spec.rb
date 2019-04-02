require 'rails_helper'

RSpec.describe AlbumSource, type: :model do

  # Validation tests
  it { should validate_presence_of(:source_id) }
  it { should validate_presence_of(:source) }
  
end