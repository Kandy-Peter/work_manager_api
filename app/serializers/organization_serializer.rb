class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :name, :country, :organization_type, :slug, :created_at, :updated_at
  has_many :users
end
