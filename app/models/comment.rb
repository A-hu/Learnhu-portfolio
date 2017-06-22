class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  has_many :like_joins, as: :likable, dependent: :destroy
  has_many :like_users, source: :user, through: :like_joins, as: :comments, dependent: :destroy

  validates :content, presence: true, length: { minimum: 10, maximum: 300 }

  after_create_commit { CommentBroadcastJob.perform_later(self) }
end
