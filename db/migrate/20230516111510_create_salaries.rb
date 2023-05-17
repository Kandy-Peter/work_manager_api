class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries, id: :uuid  do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.date :date
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :organization, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
