require 'rails_helper'

RSpec.feature 'New Registration management', type: :feature do

  let!(:dispute_analyst) { build(:dispute_analyst) }
  let!(:dispute_analyst2) { create(:dispute_analyst) }

  subject { sign_up dispute_analyst }

  context 'Dispute Analyst can sign up' do
    scenario 'with valid details' do
      subject
      expect(page).to have_text("Welcome , #{dispute_analyst.first_name}!")
    end
  end

  context 'Dispute Analyst cannot sign up' do
    scenario 'with blank fields' do
      dispute_analyst.email = nil
      dispute_analyst.password = nil
      subject
      expect(page).to have_content("can't be blank")
    end

    scenario 'when password length is short' do
      dispute_analyst.password = 'short'
      subject
      expect(page).to have_content('Password is too short')
    end

    scenario 'with invalid email format' do
      dispute_analyst.email = 'invalidemail'
      subject
      expect(page).to have_content('Email is invalid')
    end

    scenario 'with future date of birth' do
      dispute_analyst.date_of_birth = '2090-01-01'
      subject
      expect(page).to have_content('Date of birth must be in the past')
    end

    scenario 'with invalid age format' do
      dispute_analyst.age = 'twentyfive'
      subject
      expect(page).to have_content('1 error prohibited this dispute analyst from being saved')
    end

    scenario 'with valid details and additional validation' do
      dispute_analyst.age = -9
      subject
      expect(page).to have_content('Age must be greater than 0')
    end

    scenario 'with duplicate email' do
      dispute_analyst.email = dispute_analyst2.email
      subject
      expect(page).to have_content('Email has already been taken')
    end

    scenario 'when password field does not match with password_confirmation field' do
      dispute_analyst.password = 'password1'
      dispute_analyst.password_confirmation = 'password2'
      subject
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
