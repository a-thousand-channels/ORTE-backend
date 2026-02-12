# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/pages/show', type: :view do
  before(:each) do
    @page = assign(:page, Page.create!(
                            title: 'MyTitle',
                            teasertext: 'MyTeaserText',
                            fulltext: 'MyFullText',
                            footertext: 'MyFooterText'
                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/MyTitle/)
    expect(rendered).to match(/MyTeaserText/)
    expect(rendered).to match(/MyFullText/)
    expect(rendered).to match(/MyFooterText/)
  end
end
