class CreateWorkDays < ActiveRecord::Migration[7.0]
  def change
    create_table :work_days, id: :uuid do |t|
      t.datetime :day
      t.float :total_hours
      
      t.references :user, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
