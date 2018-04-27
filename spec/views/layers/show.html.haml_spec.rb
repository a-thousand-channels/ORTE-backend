require 'rails_helper'

RSpec.describe "layers/show", type: :view do
  before(:each) do
    @layer = assign(:layer, Layer.create!(
      :title => "Title",
      :text => "Text",
      :published => false,
      :map => nil
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
