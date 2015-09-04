class AddUserIdToReviewedRestaurants < ActiveRecord::Migration
  def change
    add_reference :reviewed_restaurants, :user, index: true, foreign_key: true
  end
end
