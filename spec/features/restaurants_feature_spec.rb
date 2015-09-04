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
    before(:each) do
      sign_up
      user = User.last
      user.restaurants.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit restaurants_path
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('no restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out the form and then displays the new restaurant' do
      sign_up
      user = User.last
      user.restaurants.create(name: 'KFC')

      visit restaurants_path
      expect(page).to have_content('KFC')
      expect(current_path).to eq restaurants_path
    end

    scenario 'user must be logged in to create a restaurant' do
      visit '/'
      click_link 'add restaurant'
      expect(Restaurant.count).to be(0)
      expect(page).to have_content('You need to sign in or sign up before continuing')
    end

    context 'an invalid Restaurant' do
      it 'does not let you submit a name that is too short' do
        visit restaurants_path

        click_link('Sign up')
        expect(current_path).to eq '/users/sign_up'
        sign_up
        expect(current_path).to eq '/'

        click_link 'add restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    before(:each) do
      sign_up
    end

    let!(:kfc) { User.last.restaurants.create(name: 'KFC') }

    scenario 'lets a user view a restaurant' do
      visit restaurants_path
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before(:each) do
      sign_up
      user = User.first
      user.restaurants.create(name: 'KFC')
    end

    scenario 'let a user edit a restaurant that belongs to them' do
      visit restaurants_path
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq restaurants_path
    end

    scenario 'do not let a user edit a restaurant that does not belong to them' do
      click_link 'Sign out'
      expect(page).to have_content 'Signed out successfully.'
      sign_up2
      user2 = User.last
      visit restaurants_path
      click_link 'Edit KFC'
      expect(page).to have_content 'You cannot edit that, if you did not add the restaurant'
      expect(current_path).to eq restaurants_path
    end
  end

  context 'deleting restaurants' do
    before(:each) do
      sign_up
      user = User.last
      user.restaurants.create(name: 'KFC')
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'removes all reviews for a restaurant when its deleted' do
      visit '/'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'so so'
      select '3', from: 'Rating'
      click_button 'Leave Review'
      expect(current_path).to eq restaurants_path
      click_link 'Delete KFC'
      expect(page).not_to have_content 'so so'
    end
  end
end
