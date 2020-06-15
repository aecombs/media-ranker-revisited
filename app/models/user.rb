class User < ApplicationRecord
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work

  validates :username, presence: true
  validates :uid, uniqueness: { scope: :provider }, presence: true
  validates :email, uniqueness: true, presence: true
  validates :provider, presence: true, inclusion: { in: ["github"] }


  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash["uid"]
    user.provider = auth_hash["provider"]
    user.username = auth_hash["extra"]["raw_info"]["login"]
    user.avatar = auth_hash["info"]["image"]
    user.email = auth_hash["info"]["email"]

    return user
  end
end
