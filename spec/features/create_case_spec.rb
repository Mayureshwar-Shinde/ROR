require 'rails_helper'

RSpec.feature 'CreateCase', type: :feature do
  let!(:user) { create(:user) }
  let(:curr_case) { build(:case) }

  before do
    sign_in user
  end

  subject do
    visit new_case_path
    fill_in 'Title', with: curr_case.title
    fill_in 'Description', with: curr_case.description
    click_button 'Create Case'
  end

  scenario 'User creates a new case successfully' do
    subject
    expect(page).to have_content('Case created successfully')
    expect(Case.last.user).to eq(user)
    expect(Case.last.status).to eq('open')
  end

  scenario 'User fails to create a case with missing title' do
    curr_case.title = nil
    subject
    expect(page).to have_content("Title can't be blank")
  end

  scenario 'User fails to create a case with missing description' do
    curr_case.description = nil
    subject
    expect(page).to have_content("Description can't be blank")
  end
end
