class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :country
      t.string :type

      t.timestamps
    end

    add_index :organizations, :name, unique: true
  end
end
