require 'rails_helper'

RSpec.describe Artist, type: :model do
  
  # Association test
  it { should have_many(:artist_sources) }
  it { should have_and_belong_to_many(:albums) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:img_url) }

end