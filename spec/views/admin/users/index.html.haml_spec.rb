# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/index', type: :view do
  before(:each) do
    group = FactoryBot.create(:group)
    assign(:admin_users, Kaminari.paginate_array([
                                                   FactoryBot.create(:user, :group_id => group.id),
                                                   FactoryBot.create(:user, :group_id => group.id)
                                                 ]).page(1))
  end

  it 'renders a list of admin/users' do
    render
  end
end
