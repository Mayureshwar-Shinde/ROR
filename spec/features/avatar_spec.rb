require 'rails_helper'

RSpec.feature "Avatar management", type: :feature do
  before(:each) do
    @user = create(:user)
    sign_in @user
  end

  scenario "User can update avatar with a valid image" do
    visit new_avatar_path
    attach_file('user[avatar]', Rails.root.join('app/assets/images/default_avatar.png'))
    click_button 'Update'
    expect(page).to have_content('Avatar updated successfully!')
  end

  scenario "User cannot update avatar with an invalid image" do
    visit new_avatar_path
    attach_file('user[avatar]', Rails.root.join('app/assets/images/invalid_avatar.txt'))
    click_button 'Update'
    expect(page).to have_content('Avatar has an invalid content type')
  end

  scenario "User can delete avatar" do
    visit new_avatar_path
    click_button 'Delete avatar'
    expect(page).to have_content('Avatar deleted successfully!')
    expect(page).to have_selector("span.material-symbols-outlined.dropdown", text: "account_circle")
  end

  scenario "No avatar is present, displays default icon" do
    @user.avatar.purge
    visit new_avatar_path
    expect(page).to have_selector("span.material-symbols-outlined.dropdown", text: "account_circle")
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
  end
end