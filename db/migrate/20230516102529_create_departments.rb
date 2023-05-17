class CreateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :departments, id: :uuid  do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.string :position

      t.timestamps
    end

    add_reference :departments, :organization, foreign_key: true, type: :uuid
    add_index :departments, :name, unique: true
  end
end
