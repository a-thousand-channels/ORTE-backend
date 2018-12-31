# frozen_string_literal: true

require 'rails_helper'

describe 'some stuff which requires js', js: true do
  it 'will use the specific js driver (webkit headless)', driver: :webkit do
    visit root_path
    page.should have_content('Javascript enabled')
  end
end

describe 'Guests', js: false do
  xit 'shows login form' do
    visit '/'
    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_content 'You need to sign in'
  end

  xit 'shows error if login with wrong credentials' do
    visit '/'
    fill_in 'user_email', with: 'nobody@nowhere.com'
    fill_in 'user_password', with: 'abcdefghijklmn'
    click_button 'Log in'
    expect(page).to have_content 'Invalid Email or password'
  end
end
