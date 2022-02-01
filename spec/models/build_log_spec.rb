# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildLog, type: :model do
  it 'has a valid factory' do
    expect(build(:build_log)).to be_valid
  end
end
