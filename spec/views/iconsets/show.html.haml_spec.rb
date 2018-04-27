require 'rails_helper'

RSpec.describe "iconsets/show", type: :view do
  before(:each) do
    @iconset = assign(:iconset, Iconset.create!(
      :title => "Title",
      :text => "MyText",
      :image => "Image"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Image/)
  end
end
