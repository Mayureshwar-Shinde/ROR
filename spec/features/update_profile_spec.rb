require 'rails_helper'

RSpec.feature "Update Profile Management", type: :feature do

  before(:each) do
    @user = create(:user, email: 'user@example.com', password: 'password')
    sign_in @user
  end

  scenario "User can update their profile with valid details" do
    visit edit_user_registration_path
    fill_in 'First name', with: 'latestfirstname'
    fill_in 'Last name', with: 'latestlastname'
    fill_in 'Age', with: 30
    fill_in 'Date of birth', with: '1994-08-06'
    fill_in 'Email', with: 'updated_email@example.com'
    click_button 'Update'

    expect(page).to have_text("Your account has been updated successfully.")
    expect(@user.reload.first_name).to eq('latestfirstname')
    expect(@user.reload.last_name).to eq('latestlastname')
    expect(@user.reload.age).to eq(30)
    expect(@user.reload.date_of_birth.to_s).to eq('1994-08-06')
    expect(@user.reload.email).to eq('updated_email@example.com')
  end

  scenario "User can update their password with correct current password" do
    visit edit_user_registration_path
    fill_in 'Password', with: 'newpassword'
    fill_in 'Password confirmation', with: 'newpassword'
    fill_in 'Current password', with: 'password'
    click_button 'Update'

    expect(page).to have_content("Your account has been updated successfully.")
  end

  scenario "User cannot update their profile with invalid details" do
    visit edit_user_registration_path
    fill_in 'First name', with: ''
    fill_in 'Last name', with: ''
    fill_in 'Age', with: ''
    fill_in 'Date of birth', with: ''
    fill_in 'Email', with: 'invalidemail'
    click_button 'Update'

    expect(page).to have_content("can't be blank")
    expect(page).to have_content("Age is not a number")
    expect(page).to have_content("Date of birth can't be blank")
    expect(page).to have_content("Email is invalid")
  end

  scenario "User cannot update their password with incorrect current password" do
    visit edit_user_registration_path
    fill_in 'Password', with: 'newpassword'
    fill_in 'Password confirmation', with: 'newpassword'
    fill_in 'Current password', with: 'oldpassword'
    click_button 'Update'

    expect(page).to have_content("Current password is invalid")
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end

end
