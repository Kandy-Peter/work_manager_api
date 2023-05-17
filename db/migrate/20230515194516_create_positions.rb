class CreatePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :positions, id: :uuid   do |t|
      t.string :name

      t.timestamps
    end

    add_index :positions, :name, unique: true
  end
end
