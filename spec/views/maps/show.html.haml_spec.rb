require 'rails_helper'

RSpec.describe "maps/show", type: :view do
  before(:each) do
    @map = assign(:map, Map.create!(
      :title => "Title",
      :text => "Text",
      :published => false,
      :group => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Text/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
