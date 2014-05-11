class AddRefenceIndexs < ActiveRecord::Migration
  def change
    add_index :product_translates, [:locale_id], name: 'index_product_translates_on_locale_id'
    add_index :product_translates, [:product_id], name: 'index_product_translates_on_product_id'

    add_index :orders, [:user_id], name: 'index_orders_on_user_id'

    add_index :ships, [:order_id], name: 'index_ships_on_order_id'
  end
end
