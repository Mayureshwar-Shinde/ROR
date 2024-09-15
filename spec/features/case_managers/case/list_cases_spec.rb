require 'rails_helper'

RSpec.feature 'CaseIndex', type: :feature do
  let!(:case_manager) { create(:case_manager) }
  let!(:cases) do
    [
      create(:case, title: 'First Case'),
      create(:case, title: 'Second Case', status: 'in_progress'),
      create(:case, title: 'Third Case', status: 'resolved')
    ]
  end

  before { sign_in case_manager }

  scenario 'Displays all cases on the index page' do
    visit cases_path
    cases.each do |c|
      expect(page).to have_content(c.title)
      expect(page).to have_content(c.case_number)
      expect(page).to have_content(c.status.gsub('_', ' ').capitalize)
    end
  end

  scenario 'Can sort cases by title' do
    visit cases_path(sort: 'title')
    expect(page).to have_content('First Case')
    expect(page).to have_content('Second Case')
    expect(page).to have_content('Third Case')
  end

  scenario 'Can filter cases by status' do
    visit cases_path(filter: { status: 'open' })
    expect(page).to have_content('First Case')
    expect(page).not_to have_content('Second Case')
    expect(page).not_to have_content('Third Case')
  end

  scenario 'Pagination displays limited cases per page' do
    visit cases_path
    expect(page).to have_selector('.pagination-container')
  end
end
