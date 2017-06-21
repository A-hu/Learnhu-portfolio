class Watch < ApplicationRecord
  enum status: { mixed: 0, recent: 1, popular: 2 }
  belongs_to :user
  validates_presence_of :title, :amount, :status
end
