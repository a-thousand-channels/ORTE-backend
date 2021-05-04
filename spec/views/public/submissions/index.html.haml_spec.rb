require 'rails_helper'

RSpec.describe "public/submissions/index", type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, map_id: @map.id, public_submission: false)
    assign(:map, @map)
    assign(:layer, @layer)

  end

  it "renders public_submission index (no public submission availabe)" do
    render
    
    assert_select "h1", "Submissions ORTE"
  end
end
