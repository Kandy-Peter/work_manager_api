class Reports::JourneySerializer < ActiveModel::Serializer
  attributes :id, :day, :assistances, :activities, :worked_hours, :user
end
