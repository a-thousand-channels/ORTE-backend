# frozen_string_literal: true

require 'rails_helper'


RSpec.feature 'Visitors view startpage and ' do

  background do
    # ...
  end

  scenario 'will use the specific js driver', :js => true do
    visit root_path
    expect(page).to have_content('Javascript enabled')
  end

end

RSpec.feature  'Login' do

  background do
    # ...
  end
  scenario 'shows login form', :js => true do
    visit root_path
    click_link 'Sign in'
    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_content 'Sign in'
  end

  scenario 'shows error if login with wrong credentials' do
    visit root_path
    click_link 'Sign in'
    fill_in 'user_email', with: 'nobody@nowhere.com'
    fill_in 'user_password', with: 'abcdefghijklmn'
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password'
  end
end
