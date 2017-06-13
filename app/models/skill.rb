class Skill < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :percent_utilized
end
