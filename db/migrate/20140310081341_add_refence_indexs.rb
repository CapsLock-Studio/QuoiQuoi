class AddRefenceIndexs < ActiveRecord::Migration
  def change
    add_index :product_translates, [:locale_id], name: 'index_product_translates_on_locale_id'
    add_index :product_translates, [:product_id], name: 'index_product_translates_on_product_id'

    add_index :product_custom_type_translates, [:locale_id], name: 'index_product_custom_type_translates_on_locale_id'
    add_index :product_custom_type_translates, [:product_custom_type_id], name: 'index_product_custom_type_translates_on_product_custom_type_id'

    add_index :product_custom_items, [:product_id], name: 'index_product_custom_items_on_product_id'
    add_index :product_custom_items, [:product_custom_type_id], name: 'index_product_custom_items_on_product_custom_type_id'

    add_index :product_custom_item_translates, [:locale_id], name: 'index_product_custom_item_translates_on_locale_id'
    add_index :product_custom_item_translates, [:product_custom_item_id], name: 'index_product_custom_item_translates_on_product_custom_item_id'

    add_index :goods, [:product_id], name: 'index_goods_on_product_id'
    add_index :goods, [:order_id], name: 'index_goods_on_order_id'

    add_index :good_custom_items, [:good_id], name: 'index_good_custom_items_on_good_id'
    add_index :good_custom_items, [:product_custom_item_id], name: 'index_good_custom_items_on_product_custom_item_id'

    add_index :good_custom_description_images, [:good_id], name: 'index_good_custom_description_images_on_good_id'

    add_index :orders, [:user_id], name: 'index_orders_on_user_id'

    add_index :ships, [:order_id], name: 'index_ships_on_order_id'
  end
end
