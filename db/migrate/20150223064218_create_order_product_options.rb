class CreateOrderProductOptions < ActiveRecord::Migration
  def change
    create_table :order_product_options do |t|
      t.references :order_product, index: true
      t.references :product_option, index: true
      t.float :price

      t.timestamps
    end
  end
end
