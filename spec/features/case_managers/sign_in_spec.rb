require "rails_helper"

RSpec.feature "Case Manager Login management", type: :feature do

  let(:case_manager) { create(:case_manager) }

  subject do
    visit new_case_manager_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end

  context "with valid details" do
    let(:email) { case_manager.email }
    let(:password) { case_manager.password }

    scenario "User can sign in" do
      subject
      expect(page).to have_content('Signed in successfully.')
    end
  end

  context "with invalid details" do
    let(:email) { 'wrong@example.com' }
    let(:password) { 'wrongpassword' }

    scenario "User cannot sign in" do
      subject
      expect(page).to have_content('Invalid Email or password.')
    end
  end

  context "with blank email" do
    let(:email) { nil }
    let(:password) { case_manager.password }

    scenario "User cannot sign in" do
      subject
      expect(page).to have_content('Invalid Email or password.')
    end
  end

  context "with blank password" do
    let(:email) { case_manager.email }
    let(:password) { nil }

    scenario "User cannot sign in" do
      subject
      expect(page).to have_content('Invalid Email or password.')
    end
  end

end
