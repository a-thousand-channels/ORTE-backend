require 'rails_helper'

RSpec.describe Iconset, type: :model do
  it "has a valid factory" do
    expect(build(:iconset)).to be_valid
  end
end
