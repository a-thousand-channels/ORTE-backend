# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'icons/index', type: :view do
  before(:each) do
    @iconset = FactoryBot.create(:iconset)

    assign(:icons, [
             Icon.create!(
               title: 'Title',
               iconset: @iconset
             ),
             Icon.create!(
               title: 'Title',
               iconset: @iconset
             )
           ])
  end

  it 'renders a list of icons' do
    render
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
  end
end
