class CreateDemoRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :demo_requests, id: :uuid do |t|
      t.string :full_name
      t.string :email
      t.string :phone_number
      t.string :company_name
      t.string :company_website
      t.string :how_did_you_hear_about_us
      t.integer :status, default: 0
      t.datetime :scheduled_at

      t.timestamps
    end
  end
end
