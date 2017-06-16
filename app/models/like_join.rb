class LikeJoin < ApplicationRecord
  # https://aaronvb.com/articles/a-polymorphic-join-table.html
  belongs_to :user
  belongs_to :likable, polymorphic: true
end
