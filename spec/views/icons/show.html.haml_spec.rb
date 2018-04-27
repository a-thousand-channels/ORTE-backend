require 'rails_helper'

RSpec.describe "icons/show", type: :view do
  before(:each) do
    @icon = assign(:icon, Icon.create!(
      :title => "Title",
      :image => "Image",
      :iconset => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Image/)
    expect(rendered).to match(//)
  end
end
