class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities, id: :uuid do |t|
      t.boolean :absence
      t.boolean :arrived_late
      t.boolean :worked_too_short
      t.boolean :finished_too_early
      t.boolean :incomplete_assistances
      t.datetime :day
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
