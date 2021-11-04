require 'rails_helper'

RSpec.describe Annotation, type: :model do
  it 'has a valid factory' do
    expect(build(:annotation)).to be_valid
  end
end
