require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'no restaurants yet'
      expect(page).to have_link 'add restaurant'
    end
  end
  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('no restaurants yet')
    end
  end
  context 'creating restaurants' do
    scenario 'prompts user to fill out the form and then displays the new restauran' do
      visit '/restaurants'
      click_link 'add restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content('KFC')
      expect(current_path).to eq '/restaurants'
    end
  end
end
