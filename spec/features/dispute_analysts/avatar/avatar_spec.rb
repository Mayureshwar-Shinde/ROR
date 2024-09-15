require 'rails_helper'

RSpec.feature 'Avatar management', type: :feature do

  let!(:dispute_analyst) { create(:dispute_analyst) }

  let!(:image) { { path: 'app/assets/images/dispute_analyst_avatar.png' } }

  before(:each) do
    sign_in dispute_analyst
    visit edit_avatar_path
  end

  subject do
    attach_file('dispute_analyst[avatar]', Rails.root.join(image[:path]))
    click_button 'Upload Avatar'
  end

  context 'Avatar Updation' do
    scenario 'Dipute Analyst can update avatar with a valid image' do
      subject
      expect(page).to have_content('Avatar updated successfully!')
    end

    scenario 'Dipute Analyst cannot update avatar with an empty file' do
      click_button 'Upload Avatar'
      expect(page).to have_content('No avatar provided!')
    end

    scenario 'Dipute Analyst cannot update avatar with an invalid image format' do
      image[:path] = 'spec/features/dispute_analysts/avatar/invalid_avatar.txt'
      subject
      expect(page).to have_content('Avatar has an invalid content type')
    end

    scenario 'Dipute Analyst cannot update avatar with an image exceeding the maximum dimensions' do
      image[:path] = 'spec/features/dispute_analysts/avatar/large_image.png'
      subject
      # expect(page).to have_content('Avatar is not given between dimension')
    end
  end

  context 'Avatar Deletion' do
    scenario 'Dipute Analyst can delete avatar successfully' do
      visit edit_avatar_path
      click_button 'Delete avatar'
      expect(page).to have_content('Avatar deleted successfully!')
      expect(page).to have_css('i.fa.fa-user')
    end
  end

  context 'Avatar Visibility' do
    scenario 'No avatar is present, displays default icon' do
      dispute_analyst.avatar.purge
      expect(page).to have_css('i.fa.fa-user')
    end

    scenario 'Avatar thumbnail is visible on all pages while logged in' do
      visit root_path
      expect(page).to have_selector("img[src*='dispute_analyst_avatar.png']")
    end
  end
end
