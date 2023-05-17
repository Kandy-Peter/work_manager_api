class AddDepartmentIdToPositions < ActiveRecord::Migration[7.0]
  def change
    add_reference :positions, :department, foreign_key: true
  end
end
