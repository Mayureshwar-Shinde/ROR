require 'rails_helper'

RSpec.feature "CaseManagerViewsCase", type: :feature do
  let!(:case_record) { create(:case) }

  before do
    sign_in case_record.user
    visit case_managers_case_path(case_record)
  end

  scenario "Case manager views a case" do
    expect(page).to have_content("Case #{case_record.case_number}")
    expect(page).to have_content(case_record.title)
    expect(page).to have_content(case_record.description)
    expect(page).to have_content("Status: #{case_record.status}")
    expect(page).to have_content("Created by: #{case_record.user.first_name} #{case_record.user.last_name}")
    expect(page).to have_content("Assigned to: #{case_record.assigned_to.first_name} #{case_record.assigned_to.last_name}")
  end

  scenario "Case manager redirects to case editing page on clicking 'Edit' button" do
    expect(page).to have_link("Edit", href: edit_case_managers_case_path(case_record))
    click_link 'Edit'
    expect(current_path).to eq(edit_case_managers_case_path(case_record))
  end
end
