class CreateAssistances < ActiveRecord::Migration[7.0]
  def change
    create_table :assistances, id: :uuid do |t|
      t.datetime :happened_at
      t.integer :kind
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
