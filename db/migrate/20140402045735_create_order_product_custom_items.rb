class CreateOrderProductCustomItems < ActiveRecord::Migration
  def change
    create_table :order_product_custom_items do |t|
      t.references :order_product, index: true
      t.references :product_custom_item, index: true

      t.timestamps
    end
  end
end
