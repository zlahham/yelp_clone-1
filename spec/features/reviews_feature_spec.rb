require 'rails_helper'

feature 'reviewing' do
  # before(:each) do
  #   sign_up
  #   user = User.last
  #   user.restaurants.create(name: 'KFC')
  # end

  scenario 'allows users to leave a review using a form' do
    sign_up
    user = User.last
    restaurant = user.restaurants.create(name: 'KFC')
    visit restaurants_path
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq restaurants_path
    expect(page).to have_content('so so')
  end

  xscenario 'allows users to leave only one review per Restaurant' do
  end

  scenario 'allows a user to delete their reviews' do
    sign_up
    user = User.last
    restaurant = user.restaurants.create(name: 'KFC')
    restaurant.reviews.create(thoughts: 'It was bad', rating: 1, user: user)
    visit restaurants_path
    click_button 'Delete Review'
    expect(page).not_to have_content 'It was bad'
  end

  scenario 'does not allow a user to delete reviews that they didnt create' do
    sign_up
    user = User.last
    restaurant = user.restaurants.create(name: 'KFC')
    click_link 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
    sign_up2
    user2 = User.last
    visit restaurants_path

    restaurant.reviews.create(thoughts: 'It was bad', rating: 1)
    visit restaurants_path
    click_button 'Delete Review'
    expect(page).to have_content 'It was bad'
  end
end
