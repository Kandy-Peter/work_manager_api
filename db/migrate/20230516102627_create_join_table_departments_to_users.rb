class CreateJoinTableDepartmentsToUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :departments, :users, column_options: { type: :uuid } do |t|
      t.index [:department_id, :user_id]
      t.index [:user_id, :department_id]
    end
  end
end
