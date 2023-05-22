class RemovePositionColumnFromDepartment < ActiveRecord::Migration[7.0]
  def change
    remove_column :departments, :position
  end
end
