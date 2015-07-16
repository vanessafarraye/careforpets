class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :age
      t.string :story
      t.string :owners_name
      t.string :photo_url
      t.integer :amount_needed

      t.timestamps null: false
    end
  end
end
