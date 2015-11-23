class AddColumnsToCustomOrder < ActiveRecord::Migration
  def change
    add_column :custom_orders, :price, :float
    add_column :custom_orders, :approve, :boolean
    add_reference :custom_orders, :product

    remove_reference :order_custom_items, :product
    remove_reference :order_custom_items, :user
    remove_column :order_custom_items, :design
    remove_column :order_custom_items, :style
    remove_column :order_custom_items, :description
    remove_column :order_custom_items, :response
    remove_column :order_custom_items, :workday
    remove_column :order_custom_items, :accept
    remove_column :order_custom_items, :name
    remove_column :order_custom_items, :phone
    remove_column :order_custom_items, :line
    remove_column :order_custom_items, :estimate_complete_time
    remove_column :order_custom_items, :accept_time
    remove_column :order_custom_items, :canceled
    remove_column :order_custom_items, :canceled_time
    remove_attachment :order_custom_items, :image

    add_reference :order_custom_items, :custom_order
  end
end
