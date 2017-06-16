class Topic < ApplicationRecord
  validates_presence_of :title
  validates_uniqueness_of  :title
  has_many :blogs

  has_many :like_joins, as: :likable
  has_many :like_users, source: :user, through: :like_joins, as: :topics

  def self.with_blogs
    includes(:blogs).where.not(blogs: { id: nil }).where(blogs: { status: 1 })
  end
end
