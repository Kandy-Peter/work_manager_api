class AddNewInfosToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :age, :integer
    add_column :users, :address, :string
    add_column :users, :nationality, :string
    add_column :users, :employee_numero, :string
    add_column :users, :employment_date, :date
    add_column :users, :personal_email, :string
    add_column :users, :marital_status, :string
    add_column :users, :gender, :string
    add_column :users, :national_id, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :length_of_service, :string
    add_column :users, :status, :integer, default: 0
    add_column :users, :level_of_education, :string
    add_column :users, :field_of_study, :string
    add_column :users, :university, :string
    add_column :users, :is_company_owner, :boolean, default: false
  end
end
