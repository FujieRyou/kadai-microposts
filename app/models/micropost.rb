class Micropost < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  # has_many :favorites_user, through: :favorites, source: :user
  # has_many :reverses_of_favorite, class_name: "Favorite", foreign_key: "user_id"
  
  validates :content, presence: true, length: {maximum: 255}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
