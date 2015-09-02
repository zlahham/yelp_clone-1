require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit restaurants_path
      expect(page).to have_content 'no restaurants yet'
      expect(page).to have_link 'add restaurant'
    end
  end
  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit restaurants_path
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('no restaurants yet')
    end
  end
  context 'creating restaurants' do
    scenario 'prompts user to fill out the form and then displays the new restaurant' do
      visit restaurants_path
      click_link 'add restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content('KFC')
      expect(current_path).to eq restaurants_path
    end
  end
  context 'viewing restaurants' do
    let!(:kfc) { Restaurant.create(name: 'KFC') }

    scenario 'lets a user view a restaurant' do
      visit restaurants_path
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end
  context 'editing restaurants' do
    # the before statment creates an entry in the db, whereas the let in the previous test simply creates a double
    before { Restaurant.create name: 'KFC' }

    scenario 'let a user edit a restaurant' do
      visit restaurants_path
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq restaurants_path
    end
  end

  context 'deleting restaurants' do
    before { Restaurant.create(name: 'KFC') }

    scenario 'removes ta restaurant when a user clicks a delete link' do
      visit restaurants_path
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end
  end
end
