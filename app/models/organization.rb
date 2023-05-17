class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :users
  has_many :departments, dependent: :destroy
  has_many :positions, dependent: :destroy

  validates :name, presence: true
end
