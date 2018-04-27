require 'rails_helper'

RSpec.describe "groups/index", type: :view do
  before(:each) do
    assign(:groups, [
      Group.create!(
        :title => "Title",
        :user => nil
      ),
      Group.create!(
        :title => "Title",
        :user => nil
      )
    ])
  end

  it "renders a list of groups" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
