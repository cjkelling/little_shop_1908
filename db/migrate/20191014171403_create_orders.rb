class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :customer_name
      t.string :customer_address
      t.string :customer_city
      t.string :customer_state
      t.integer :customer_zip
      t.bigint :order_number
      t.timestamps
    end
  end
end
