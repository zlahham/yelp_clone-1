class Restaurant < ActiveRecord::Base
  validates :name, length: { minimum: 3 }, uniqueness: true
  validates :user, presence: true
  belongs_to :user
  has_many :reviews, -> { extending WithUserAssociationExtension }, dependent: :destroy

  def build_review(attributes = {}, user)
    review = reviews.build(attributes)
    review.user = user
    review
  end
end
