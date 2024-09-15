require 'rails_helper'

RSpec.feature 'New Registration management', type: :feature do

  let!(:case_manager) { build(:case_manager) }
  let!(:case_manager2) { create(:case_manager) }

  subject { sign_up case_manager }

  context 'Case Manager can sign up' do
    scenario 'with valid details' do
      subject
      expect(page).to have_text("Welcome , #{case_manager.first_name}!")
    end
  end

  context 'Case Manager cannot sign up' do
    scenario 'with blank fields' do
      case_manager.email = nil
      case_manager.password = nil
      subject
      expect(page).to have_content("can't be blank")
    end

    scenario 'when password length is short' do
      case_manager.password = 'short'
      subject
      expect(page).to have_content('Password is too short')
    end

    scenario 'with invalid email format' do
      case_manager.email = 'invalidemail'
      subject
      expect(page).to have_content('Email is invalid')
    end

    scenario 'with future date of birth' do
      case_manager.date_of_birth = '2090-01-01'
      subject
      expect(page).to have_content('Date of birth must be in the past')
    end

    scenario 'with invalid age format' do
      case_manager.age = 'twentyfive'
      subject
      expect(page).to have_content('1 error prohibited this case manager from being saved')
    end

    scenario 'with valid details and additional validation' do
      case_manager.age = -9
      subject
      expect(page).to have_content('Age must be greater than 0')
    end

    scenario 'with duplicate email' do
      case_manager.email = case_manager2.email
      subject
      expect(page).to have_content('Email has already been taken')
    end

    scenario 'when password field does not match with password_confirmation field' do
      case_manager.password = 'password1'
      case_manager.password_confirmation = 'password2'
      subject
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end

end
