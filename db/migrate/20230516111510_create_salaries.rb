class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.date :date
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
