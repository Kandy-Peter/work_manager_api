class Department <ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :users

  validates :name, :description, presence: true
  validates :name, uniqueness: true
end
