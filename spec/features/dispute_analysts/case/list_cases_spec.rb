require 'rails_helper'

RSpec.feature 'DisputeAnalystCaseIndex', type: :feature do
  let!(:dispute_analyst) { create(:dispute_analyst) }
  let!(:assigned_case) { create(:case, assigned_to: dispute_analyst, status: 'in_progress', title: 'Assigned Case') }
  let!(:unassigned_case) { create(:case, assigned_to: nil, status: 'open', title: 'Unassigned Case') }

  before do
    sign_in dispute_analyst
    visit cases_path
  end

  scenario 'Displays only cases assigned to the dispute analyst' do
    expect(page).to have_content('Assigned Case')
    expect(page).not_to have_content('Unassigned Case')
  end

  scenario 'Can sort cases by title' do
    visit cases_path(sort: 'title')
    expect(page).to have_content('Assigned Case')
  end

  scenario 'Can filter cases by status' do
    visit cases_path(filter: { status: 'in_progress' })
    expect(page).to have_content('Assigned Case')
    expect(page).not_to have_content('Unassigned Case')
  end

  scenario 'Pagination displays limited cases per page' do
    expect(page).to have_selector('.pagination-container')
  end
end
