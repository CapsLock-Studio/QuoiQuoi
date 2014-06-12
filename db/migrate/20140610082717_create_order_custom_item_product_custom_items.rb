class CreateOrderCustomItemProductCustomItems < ActiveRecord::Migration
  def change
    create_table :order_custom_item_product_custom_items do |t|
      t.references :order_custom_item, index: {name: 'order_custom_item_on_product_custom_item'}
      t.references :product_custom_item, index: {name: 'product_custom_item_order_custom_item'}

      t.timestamps
    end
  end
end
