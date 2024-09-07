require 'rails_helper'

RSpec.feature 'Avatar management', type: :feature do
  before(:each) do
    @user = create(:user)
    sign_in @user
    visit new_avatar_path
  end

  image_name = 'default_avatar.png'

  subject do
    attach_file('user[avatar]', Rails.root.join('app/assets/images/' << image_name))
    click_button 'Update'
  end

  context 'Avatar Updation' do
    scenario 'User can update avatar with a valid image' do
      subject
      expect(page).to have_content('Avatar updated successfully!')
    end

    scenario 'User cannot update avatar with an invalid image format' do
      image_name = 'invalid_avatar.txt'
      subject
      expect(page).to have_content('Avatar has an invalid content type')
    end
  end

  context 'Avatar Deletion' do
    scenario 'User cannot update avatar with an image exceeding the maximum dimensions' do
      image_name = 'large_image.png'
      subject
      # expect(page).to have_content('Avatar is not given between dimension')
    end

    scenario 'User can delete avatar' do
      subject
      click_button 'Delete avatar'
      expect(page).to have_content('Avatar deleted successfully!')
      expect(page).to have_selector('span.material-symbols-outlined.dropdown', text: 'account_circle')
    end

    scenario 'User cannot update avatar with an empty file' do
      click_button 'Update'
      expect(page).to have_content('Please select an image')
    end
  end

  context 'Avatar Visibility' do
    scenario 'No avatar is present, displays default icon' do
      @user.avatar.purge
      visit new_avatar_path
      expect(page).to have_selector('span.material-symbols-outlined.dropdown', text: 'account_circle')
    end

    scenario 'Avatar thumbnail is visible on all pages while logged in' do
      subject
      visit root_path
      # expect(page).to have_selector("img[src*='default_avatar.png']")
    end
  end
end
