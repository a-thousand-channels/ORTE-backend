require 'rails_helper'

RSpec.describe Layer, type: :model do
  it "has a valid factory" do
    expect(build(:layer)).to be_valid
  end
end
