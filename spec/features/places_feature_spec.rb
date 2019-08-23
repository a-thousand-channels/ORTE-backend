# frozen_string_literal: true

require 'rails_helper'


RSpec.feature 'User create and updates a place ' do

  before do
    @group = FactoryBot.create(:group)
    user = FactoryBot.create(:admin_user, :group_id => @group.id)
    visit root_path
    click_link 'Sign in'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Log in'
  end

  scenario 'shows edit form (and provide only allowed layers to select)', :js => true do
    @map = FactoryBot.create(:map, :group_id => @group.id)
    @layer = FactoryBot.create(:layer, :map_id=> @map.id, :title=>"my layer")

    @other_group = FactoryBot.create(:group)
    @other_map = FactoryBot.create(:map, :group_id => @other_group.id)
    @other_layer = FactoryBot.create(:layer, :map_id=> @other_map.id, :title=>"other layer")
    @place = FactoryBot.create(:place, :layer_id => @layer.id)
    visit edit_map_layer_place_path(@map,@layer,@place)
    expect(page).to have_content 'my layer'
    expect(page).not_to have_content 'other layer'

  end


end
