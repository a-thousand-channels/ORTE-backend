require 'rails_helper'

RSpec.describe "icons/show", type: :view do
  before(:each) do
    @iconset = FactoryBot.create(:iconset)
    @icon = FactoryBot.create(:icon, :iconset_id => @iconset.id)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Image/)
  end
end
