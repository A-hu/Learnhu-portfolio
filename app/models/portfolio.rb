class Portfolio < ApplicationRecord
  validates_presence_of :title, :body, :main_image, :thumb_image

  scope :ruby_on_rails_portfolio_items, -> { where(subtitle: 'RubyonRails') }
  scope :angular, -> { where(subtitle: 'AngularJS') }
end
