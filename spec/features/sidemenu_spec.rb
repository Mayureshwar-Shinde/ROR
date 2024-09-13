require 'rails_helper'

RSpec.feature 'Sidebar Menu', type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit root_path
  end

  scenario 'User sees the sidebar menu' do
    expect(page).to have_selector('.sidenav.collapsible')
  end

  scenario 'Menu options are correctly displayed' do
    expect(page).to have_selector('button.dropdown-btn', text: 'MyProfile')
    expect(page).to have_selector('button.dropdown-btn', text: 'Cases')
    expect(page).to have_selector('.signout-btn', text: 'Sign out')
  end

  scenario 'User can sign out successfully' do
    click_button 'Sign out'
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Signed out successfully.')
  end

  scenario 'Dropdown for MyProfile expands and collapses' do
    find('button.dropdown-btn', text: 'MyProfile').click
    expect(page).to have_selector('.dropdown-container', visible: true)

    find('button.dropdown-btn', text: 'MyProfile').click
    expect(page).to have_selector('.dropdown-container', visible: false)
  end

  scenario 'Dropdown for Cases expands and collapses' do
    find('button.dropdown-btn', text: 'Cases').click
    expect(page).to have_selector('.dropdown-container', visible: true)

    find('button.dropdown-btn', text: 'Cases').click
    expect(page).to have_selector('.dropdown-container', visible: false)
  end
end
