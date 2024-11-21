# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/pages/index', type: :view do
  before(:each) do
    assign(:pages, [
             Page.create!(
               title: 'Title1',
               fulltext: 'MyText'
             ),
             Page.create!(
               title: 'Title2',
               fulltext: 'MyText'
             )
           ])
  end

  it 'renders a list of pages' do
    render
    expect(rendered).to match(/Title1/)
    expect(rendered).to match(/Title2/)
  end
end
