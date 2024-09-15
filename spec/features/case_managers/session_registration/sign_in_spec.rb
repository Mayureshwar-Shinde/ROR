require 'rails_helper'

RSpec.feature 'Login management', type: :feature do

  let!(:case_manager) { create(:case_manager) }

  context 'Case Manager fails to sign in' do
    scenario 'when password is kept blank' do
      case_manager.email = nil
      sign_in case_manager
      expect(page).to have_content('Invalid Email or password.')
    end

    scenario 'when email is kept blank' do
      case_manager.password = nil
      sign_in case_manager
      expect(page).to have_content('Invalid Email or password.')
    end

    scenario 'with invalid details' do
      case_manager.email = 'wrong@example.com'
      case_manager.password = 'wrongpassword'
      sign_in case_manager
      expect(page).to have_content('Invalid Email or password.')
    end
  end

  context 'Case Manager signs in successfully' do
    scenario 'with valid details' do
      sign_in case_manager
      expect(page).to have_content('Signed in successfully.')
    end
  end

end
