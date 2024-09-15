require 'rails_helper'

RSpec.feature 'Login management', type: :feature do

  let!(:dispute_analyst) { create(:dispute_analyst) }

  context 'Dispute Analyst fails to sign in' do
    scenario 'when password is kept blank' do
      dispute_analyst.email = nil
      sign_in dispute_analyst
      expect(page).to have_content('Invalid Email or password.')
    end

    scenario 'when email is kept blank' do
      dispute_analyst.password = nil
      sign_in dispute_analyst
      expect(page).to have_content('Invalid Email or password.')
    end

    scenario 'with invalid details' do
      dispute_analyst.email = 'wrong@example.com'
      dispute_analyst.password = 'wrongpassword'
      sign_in dispute_analyst
      expect(page).to have_content('Invalid Email or password.')
    end
  end

  context 'Dispute Analyst signs in successfully' do
    scenario 'with valid details' do
      sign_in dispute_analyst
      expect(page).to have_content('Signed in successfully.')
    end
  end

end
