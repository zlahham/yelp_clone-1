class CreateReviewedRestaurants < ActiveRecord::Migration
  def change
    create_table :reviewed_restaurants do |t|

      t.timestamps null: false
    end
  end
end
