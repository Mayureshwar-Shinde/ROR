require 'rails_helper'

RSpec.feature "CreateCase", type: :feature do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  scenario 'User creates a new case successfully' do
    visit new_case_path

    fill_in 'Title', with: 'Test Case Title'
    fill_in 'Description', with: 'Test Case Description'
    click_button 'Create Case'

    expect(page).to have_content('Case created successfully')
    expect(Case.last.user).to eq(user)
    expect(Case.last.status).to eq('open')
  end

  scenario 'User fails to create a case with missing title' do
    visit new_case_path

    fill_in 'Description', with: 'Test Case Description'
    click_button 'Create Case'

    expect(page).to have_content("Title can't be blank")
  end

  scenario 'User fails to create a case with missing description' do
    visit new_case_path

    fill_in 'Title', with: 'Test Case Title'
    click_button 'Create Case'

    expect(page).to have_content("Description can't be blank")
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
end
