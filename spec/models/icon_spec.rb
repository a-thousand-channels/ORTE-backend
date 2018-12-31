require 'rails_helper'

RSpec.describe Icon, type: :model do
  it "has a valid factory" do
    expect(build(:icon)).to be_valid
  end
end
