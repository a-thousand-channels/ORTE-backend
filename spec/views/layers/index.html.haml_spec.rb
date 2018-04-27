require 'rails_helper'

RSpec.describe "layers/index", type: :view do
  before(:each) do
    assign(:layers, [
      Layer.create!(
        :title => "Title",
        :text => "Text",
        :published => false,
        :map => nil
      ),
      Layer.create!(
        :title => "Title",
        :text => "Text",
        :published => false,
        :map => nil
      )
    ])
  end

  it "renders a list of layers" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
