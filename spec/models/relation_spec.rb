# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relation, type: :model do
  it 'has a valid factory' do
    p1 = create(:place)
    p2 = create(:place)
    expect(build(:relation, relation_from_id: p1.id, relation_to_id: p2.id)).to be_valid
  end

  describe 'associations' do
    subject { build(:relation) }
    it { is_expected.to belong_to(:relation_to) }
    it { is_expected.to belong_to(:relation_from) }
  end

  it 'has valid relation titles' do
    p1 = create(:place, title: 'Yellow')
    p2 = create(:place, title: 'Green')
    r = create(:relation, relation_from_id: p1.id, relation_to_id: p2.id)
    expect(r.relation_from.title).to eq('Yellow')
    expect(r.relation_to.title).to eq('Green')
  end
end
