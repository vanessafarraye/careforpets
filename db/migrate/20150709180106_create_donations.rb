class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :user_id
      t.integer :client_id
      t.integer :amount
      t.integer :transaction_id

      t.timestamps null: false
    end
  end
end
