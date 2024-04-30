class User < ApplicationRecord
  # 文字をすべて小文字に変換するというもの
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :favorites, dependent: :destroy
  has_many :favorites_microposts, through: :favorites, source: :microposts
  has_many :reverses_of_favorite, class_name: "Favorite", foreign_key: "micropost_id"

  def follow(other_user)
    # # other_userが自分自身ではないかを検証しています
    unless self == other_user
      # 見つかればRelationshipモデル（クラス）のインスタンスを返します。見つからなければフォロー関係を保存（create = build + save）できます
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  # フォローがあれば外す
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  # すでにフォローしているかどうかもわかるように
  def following?(other_user)
  # ther_user が含まれていないかを確認しています。含まれている場合には、true を返し、含まれていない場合には、false を返します。
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  def like(other_user)
    unless self == other_user
      self.microposts.find_or_create_by(micropost_id: other_user.id)
    end
  end
  
  def unlike(other_user)
    favorite = self.favorites.find_by(micropost_id: other_user.id)
    favorite.destroy if favorite
  end
end

