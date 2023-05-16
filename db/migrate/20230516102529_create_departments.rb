class CreateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps
    end

    add_reference :departments, :organization, foreign_key: true
  end
end
