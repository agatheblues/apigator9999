require "rails_helper"

RSpec.describe Genre, type: :model do
  # model associations
  it { should have_and_belong_to_many(:albums) }

  # Validation tests
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:name) }
end
