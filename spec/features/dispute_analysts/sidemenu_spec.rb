require 'rails_helper'

RSpec.feature 'Sidebar Menu', type: :feature do
  let(:dispute_analyst) { create(:dispute_analyst) }

  before { sign_in dispute_analyst }

  scenario 'Dispute Analyst sees the sidebar menu' do
    expect(page).to have_selector('.sidenav.collapsible')
  end

  scenario 'Menu options are correctly displayed' do
    expect(page).to have_selector('button.dropdown-btn', text: 'MyProfile')
    expect(page).to have_selector('button.dropdown-btn', text: 'Cases')
    expect(page).to have_selector('.signout-btn', text: 'Sign out')
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

  scenario 'Cases dropdown links lead to correct paths' do
    find('button.dropdown-btn', text: 'Cases').click
    click_link 'List all Cases'
    expect(page).to have_current_path(dispute_analysts_cases_path)
  end

  scenario 'MyProfile dropdown links lead to correct paths' do
    find('button.dropdown-btn', text: 'MyProfile').click
    click_link 'Update Avatar'
    expect(page).to have_current_path(edit_avatar_path)

    visit root_path
    find('button.dropdown-btn', text: 'MyProfile').click
    click_link 'Update personal data'
    expect(page).to have_current_path(edit_dispute_analyst_registration_path)
  end

  scenario 'Dispute Analyst can sign out successfully' do
    click_button 'Sign out'
    expect(page).to have_current_path(root_path)
    expect(page).to have_content('Signed out successfully.')
  end
end
