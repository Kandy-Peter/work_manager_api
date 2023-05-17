class AddSlugToDepartments < ActiveRecord::Migration[7.0]
  def change
    add_column :departments, :slug, :string
  end
end
