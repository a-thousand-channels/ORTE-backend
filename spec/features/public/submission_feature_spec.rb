# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User create and updates a submission, place and image ' do
  before do
    @map = FactoryBot.create(:map)
    submission_config = FactoryBot.create(:submission_config, layer_id: @layer, title_intro: 'submission_config_test')
    @layer = FactoryBot.create(:layer, map: @map, public_submission: true, submission_config: submission_config)
  end

  scenario 'shows create new submission form, fill out form and submit', js: true do
    visit new_submission_path(layer_id: @layer.id, locale: 'en')
    expect(page).to have_content 'submission_config_test'
    fill_in 'submission_name', with: 'My first submission'
    fill_in 'submission_email', with: 'test@test.org'
    check 'submission_rights'
    check 'submission_privacy'
    click_button('Go to step 2') # submits the form
    expect(page).to have_content 'Your data has been saved (Step 1).'
    submission = Submission.all.last
    expect(page).to have_current_path submission_new_place_path(layer_id: @layer.id, locale: 'en', submission_id: submission.id)
    # click_link '1 Personal data' # -> not working (friendly path?)
    visit edit_submission_path(layer_id: @layer.id, locale: 'en', id: submission.id)
    expect(page).to have_current_path edit_submission_path(layer_id: @layer.id, locale: 'en', id: submission.id)
    fill_in 'submission_name', with: 'My first submission, title corrected before creation of place'
    click_button('Go to step 2') # submits the form
    expect(page).to have_css('h3#submission_name_receiver')
    expect(page).to have_content('My first submission, title corrected before creation of place')
  end
end
