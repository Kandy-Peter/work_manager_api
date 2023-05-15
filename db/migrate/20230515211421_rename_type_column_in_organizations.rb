class RenameTypeColumnInOrganizations < ActiveRecord::Migration[7.0]
  def change
    rename_column :organizations, :type, :organization_type
  end
end
