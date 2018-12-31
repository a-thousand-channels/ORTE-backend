require 'rails_helper'

RSpec.describe Map, type: :model do
  it "has a valid factory" do
    expect(build(:map)).to be_valid
  end
end
