# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'icons/new', type: :view do
  before(:each) do
    @iconset = FactoryBot.create(:iconset)
    @icon = FactoryBot.create(:icon, iconset_id: @iconset.id)
    assign(:icon, Icon.new(
                    title: 'MyString',
                    iconset: @iconset
                  ))
  end

  it 'renders new icon form' do
    render

    assert_select 'form[action=?][method=?]', iconset_icons_path(@iconset), 'post' do
      assert_select 'input[name=?]', 'icon[title]'

    end
  end
end
