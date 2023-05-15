class AddOrganizationIdToPositions < ActiveRecord::Migration[7.0]
  def change
    add_reference :positions, :organization, foreign_key: true
  end
end
