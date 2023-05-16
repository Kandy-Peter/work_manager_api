class Organization < ApplicationRecord
  has_many :users
  has_many :departments, dependent: :destroy
  has_many :positions, dependent: :destroy

  validates :name, presence: true
end
