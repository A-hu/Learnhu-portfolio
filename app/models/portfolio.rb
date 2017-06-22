class Portfolio < ApplicationRecord
  has_many :technologies, dependent: :destroy

  has_many :like_joins, as: :likable, dependent: :destroy
  has_many :like_users, source: :user, through: :like_joins, as: :portfolios, dependent: :destroy

  accepts_nested_attributes_for :technologies,
                                allow_destroy: true,
                                reject_if: lambda { |attrs| attrs['name'].blank? }

  validates_presence_of :title, :body

  mount_uploader :thumb_image, PortfolioUploader
  mount_uploader :main_image, PortfolioUploader

  scope :ruby_on_rails_portfolio_items, -> { where(subtitle: 'RubyonRails') }
  scope :angular, -> { where(subtitle: 'AngularJS') }

  def self.by_position
    order("position ASC")
  end
end
