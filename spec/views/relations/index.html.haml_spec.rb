# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'relations/index', type: :view do
  before(:each) do
    @map = create(:map)
    layer = create(:layer, map: @map)
    @layers = [layer]
    p1 = create(:place, layer: layer)
    p2 = create(:place, layer: layer)
    assign(:relations, [
             create(:relation, relation_from_id: p1.id, relation_to_id: p2.id),
             create(:relation, relation_from_id: p2.id, relation_to_id: p1.id)
           ])
  end

  it 'renders a list of relations' do
    render
  end
end
