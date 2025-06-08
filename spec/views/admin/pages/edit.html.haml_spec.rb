# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/pages/edit', type: :view do
  before(:each) do
    @page = assign(:page, Page.create!(
                            title: 'MyString',
                            teasertext: 'MyText'
                          ))
  end

  it 'renders the edit page form' do
    render

    assert_select 'form[action=?][method=?]', admin_page_path(@page), 'post' do
      assert_select 'input[name=?]', 'page[title]'
      assert_select 'textarea[name=?]', 'page[teasertext]'
    end
  end
end
