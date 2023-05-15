class Organization < ApplicationRecord
  has_many :users
  has_many :positions, dependent: :destroy
end
