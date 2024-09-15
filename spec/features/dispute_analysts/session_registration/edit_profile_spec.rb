require 'rails_helper'

RSpec.feature 'Update Profile Management', type: :feature do

  let!(:dispute_analyst) { create(:dispute_analyst) }
  let!(:valid_attributes) { attributes_for(:dispute_analyst) }
  let!(:attributes) { Hash.new }

  before do
    sign_in dispute_analyst
    visit edit_dispute_analyst_registration_path
  end

  subject do
    attributes.compact!
    attributes.each { |key, value| fill_in key.to_s.gsub('_', ' ').capitalize, with: value }
    click_button 'Update'
  end

  def update_password(new_password, confirmation, current)
    attributes[:password] = new_password
    attributes[:password_confirmation] = confirmation
    attributes[:current_password] = current
    subject
  end

  context 'Dispute Analyst can update profile' do
    scenario 'with valid details' do
      attributes.merge!(valid_attributes, password: nil, password_confirmation: nil, role_type: nil)
      subject
      dispute_analyst.reload
      expect(page).to have_text('Your account has been updated successfully.')
      expect(dispute_analyst.first_name).to eq(attributes[:first_name])
      expect(dispute_analyst.last_name).to eq(attributes[:last_name])
      expect(dispute_analyst.age).to eq(attributes[:age])
      expect(dispute_analyst.date_of_birth).to eq(attributes[:date_of_birth])
      expect(dispute_analyst.email).to eq(attributes[:email].downcase)
    end

    scenario 'password with correct current password' do
      update_password('newpassword', 'newpassword', dispute_analyst.password)
      expect(page).to have_content('Your account has been updated successfully.')
    end
  end

  context 'Dispute Analyst cannot update profile' do
    scenario 'with blank fields' do
      attributes[:first_name] = ''
      attributes[:last_name] = ''
      attributes[:age] = ''
      attributes[:date_of_birth] = ''
      subject
      expect(page).to have_content("can't be blank")
    end

    scenario 'password with incorrect current password' do
      update_password('newpassword', 'newpassword', 'incorrect')
      expect(page).to have_content('Current password is invalid')
    end

    scenario 'when password is too short' do
      update_password('short', 'short', dispute_analyst.password)
      expect(page).to have_content('Password is too short')
    end

    scenario 'with future date of birth' do
      attributes[:date_of_birth] = '2090-01-01'
      subject
      expect(page).to have_content('Date of birth must be in the past')
    end

    scenario 'with invalid age format' do
      attributes[:age] = -9
      subject
      expect(page).to have_content('Age must be greater than 0')
    end

    scenario 'when password confirmation does not match password' do
      update_password('password1', 'password2', dispute_analyst.password)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    scenario 'with duplicate email' do
      dispute_analyst2 = create(:dispute_analyst)
      attributes[:email] = dispute_analyst2.email
      subject
      expect(page).to have_content('Email has already been taken')
    end
  end

  context 'Dispute Analyst cancels account' do
    scenario 'successfully' do
      click_button 'Cancel my account'
      expect(page).to have_text('Bye! Your account has been successfully cancelled.')
    end
  end
end
