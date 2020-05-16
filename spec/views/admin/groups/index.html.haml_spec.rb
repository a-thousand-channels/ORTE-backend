# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/groups/index', type: :view do
  before(:each) do
    @admin_groups = assign(:groups, [
                             Group.create!(
                               title: 'Title1'
                             ),
                             Group.create!(
                               title: 'Title2'
                             )
                           ])
  end

  it 'renders a list of groups' do
    render
    expect(rendered).to match(/Title1/)
    expect(rendered).to match(/Title2/)
  end
end
