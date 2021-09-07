# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Submission, type: :model do
  it 'has a valid factory' do
    expect(build(:submission)).to be_valid
  end
end
