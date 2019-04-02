require 'rails_helper'

RSpec.describe Album, type: :model do
  
  # Association test
  it { should have_and_belong_to_many(:genres) }
  it { should have_and_belong_to_many(:artists) }
  it { should have_many(:album_sources) }
  
  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:added_at) }
  it { should validate_presence_of(:release_date) }
  it { should validate_presence_of(:total_tracks) }
  it { should validate_presence_of(:img_url) }
  it { should validate_presence_of(:height) }
  it { should validate_presence_of(:width) }

end