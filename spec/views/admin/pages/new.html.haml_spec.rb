# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/pages/new', type: :view do
  before(:each) do
    assign(:page, Page.new(
                    title: 'MyTitle',
                    teasertext: 'MyText'
                  ))
  end

  it 'renders new page form' do
    render

    assert_select 'form[action=?][method=?]', admin_pages_path, 'post' do
      assert_select 'input[name=?]', 'page[title]'

      assert_select 'textarea[name=?]', 'page[teasertext]'
    end
  end
end
