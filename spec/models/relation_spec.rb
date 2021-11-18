# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relation, type: :model do
  it 'has a valid factory' do
    p1 = create(:place)
    p2 = create(:place)
    expect(build(:relation, relation_from_id: p1.id, relation_to_id: p2.id)).to be_valid
  end
end