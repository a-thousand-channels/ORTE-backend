# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'iconsets/index', type: :view do
  before(:each) do
    assign(:iconsets, [
             Iconset.create!(
               title: 'Title1',
               text: 'MyText',
               image: 'Image'
             ),
             Iconset.create!(
               title: 'Title2',
               text: 'MyText',
               image: 'Image'
             )
           ])
  end

  it 'renders a list of iconsets' do
    render
    expect(rendered).to match(/Title1/)
    expect(rendered).to match(/Title2/)
  end
end
