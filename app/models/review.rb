class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user

  # validates :user_id, uniqueness: true
  validates :user_id, uniqueness: { scope: :restaurant, message: "has reviewed this restaurant already" }
  validates :rating, inclusion: (1..5)
end
