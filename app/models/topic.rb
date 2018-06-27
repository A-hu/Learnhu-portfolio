class Topic < ApplicationRecord
  validates_presence_of :title
  validates_uniqueness_of  :title

  has_many :blogs

  has_many :like_joins, as: :likable, dependent: :destroy
  has_many :like_users, source: :user, through: :like_joins, as: :topics, dependent: :destroy

  after_create :auto_subscription

  def self.with_blogs
    includes(:blogs).where.not(blogs: { id: nil }).where.not(blogs: { status: 0 }).order(updated_at: :desc)
  end

  def self.with_weekly_blogs
    includes(:blogs).where.not(blogs: { status: 0}).where(blogs: {created_at: (Time.now - 7.days)..Time.now})
  end

  def auto_subscription
    User.all.each do |user|
      user.like_topics << self
    end
  end
end
