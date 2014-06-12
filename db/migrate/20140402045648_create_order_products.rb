class CreateOrderProducts < ActiveRecord::Migration
  def change
    create_table :order_products do |t|
      t.references :order, show: true
      t.references :product, show: true
      t.integer :quantity

      t.timestamps
    end
  end
end
