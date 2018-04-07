# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/index', type: :view do
  before(:each) do
    assign(:admin_users, Kaminari.paginate_array([
                                                   FactoryBot.create(:user),
                                                   FactoryBot.create(:user)
                                                 ]).page(1))
  end

  it 'renders a list of admin/users' do
    render
  end
end
