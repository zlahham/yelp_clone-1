class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :rating, inclusion: (1..5)
end
