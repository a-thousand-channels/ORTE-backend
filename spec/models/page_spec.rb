# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page, type: :model do
  it 'has a valid factory' do
    expect(build(:place)).to be_valid
  end

  it 'has a valid factory (with sensitive on)' do
    expect(build(:place, sensitive: true)).to be_valid
  end

  it 'is invalid without a title' do
    expect(build(:place, title: nil)).not_to be_valid
  end
end
