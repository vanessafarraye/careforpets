class AddDateExpectSToClients < ActiveRecord::Migration
  def change
    add_column :clients, :date_expect, :string
  end
end
