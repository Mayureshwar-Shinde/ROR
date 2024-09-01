require "rails_helper"

RSpec.feature "New Registration management", type: :feature do

  let(:case_manager) { build(:case_manager) }

  subject do
    visit new_case_manager_registration_path
    fill_in 'First name', with: case_manager.first_name
    fill_in 'Last name', with: case_manager.last_name
    fill_in 'Age', with: case_manager.age
    fill_in 'Date of birth', with: case_manager.date_of_birth
    fill_in 'Email', with: 'tracy@jonas.com'
    fill_in 'Password', with: case_manager.password
    fill_in 'Password confirmation', with: case_manager.password
  end

  context "with valid details" do
    scenario "User can sign up" do
      subject
      click_button 'Sign up'
      expect(page).to have_text("Welcome , #{case_manager.first_name}!")
    end
  end

  context "with invalid details" do
    scenario "User cannot sign up with blank details" do
      subject
      fill_in 'Email', with: nil
      fill_in 'Password', with: nil
      fill_in 'Password confirmation', with: nil
      click_button 'Sign up'
      expect(page).to have_content("can't be blank")
    end
  end

  context "with mismatched password confirmation" do
    scenario "User cannot sign up with mismatched password confirmation" do
      subject
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'differentpassword'
      click_button 'Sign up'
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end

  context "with short password" do
    scenario "User cannot sign up with short password" do
      subject
      fill_in 'Password', with: 'short'
      fill_in 'Password confirmation', with: 'short'
      click_button 'Sign up'
      expect(page).to have_content("Password is too short")
    end
  end

  context "with duplicate email" do
    let!(:existing_user) { create(:case_manager, email: 'duplicate@example.com') }
    scenario "User cannot sign up with duplicate email" do
      subject
      fill_in 'Email', with: existing_user.email
      click_button 'Sign up'
      expect(page).to have_content("Email has already been taken")
    end
  end

  context "with invalid email format" do
    scenario "User cannot sign up with invalid email format" do
      subject
      fill_in 'Email', with: 'invalidemail'
      click_button 'Sign up'
      expect(page).to have_content("Email is invalid")
    end
  end

  context "with special characters in fields" do
    scenario "User can sign up with special characters in fields" do
      subject
      fill_in 'First name', with: 'Tr@cy!'
      fill_in 'Last name', with: 'J#nas'
      click_button 'Sign up'
      expect(page).to have_text("Welcome , Tr@cy!!")
    end
  end

  context "with future date of birth" do
    scenario "User cannot sign up with future date of birth" do
      subject
      fill_in 'Date of birth', with: '2090-01-01'
      click_button 'Sign up'
      expect(page).to have_content("Date of birth must be in the past")
    end
  end

  context "with invalid age format" do
    scenario "User cannot sign up with invalid age format" do
      subject
      fill_in 'Age', with: 'twenty-five'
      click_button 'Sign up'
      expect(page).to have_content("Age is not a number")
    end
  end

  context "with valid details and additional validation" do
    scenario "User cannot sign up with age under minimum required" do
      subject
      fill_in 'Age', with: -9
      click_button 'Sign up'
      expect(page).to have_content("Age must be greater than 17")
    end
  end

end
