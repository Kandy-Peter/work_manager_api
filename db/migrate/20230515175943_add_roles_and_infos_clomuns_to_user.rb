class AddRolesAndInfosClomunsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :is_admin, :boolean, default: false
    add_column :users, :salary, :integer, default: 0
    add_column :users, :country, :string, default: "Kenya"
    add_column :users, :city, :string, default: "Nairobi"
    add_column :users, :phone_number, :string, default: ""
    add_column :users, :zip, :string, default: ""
  end
end
