class Blog < ApplicationRecord
  enum status: { draft: 0, published: 1, sticky: 2 }
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates_presence_of :title, :body, :topic_id

  belongs_to :topic, touch: true

  has_many :comments, dependent: :destroy

  has_many :like_joins, as: :likable, dependent: :destroy
  has_many :like_users, source: :user, through: :like_joins, as: :blogs, dependent: :destroy

  def self.recent
    order('created_at DESC')
  end

  def self.not_draft
    where.not(status: "draft")
  end

  def self.prior
    order('status DESC')
  end

  def self.weekly_news
    where(created_at: (Time.now - 7.days)..Time.now).recent.not_draft
  end

  def clean_body
    self.body.tr('#`*=_', ' ').tr('  ', ' ')
  end
end
