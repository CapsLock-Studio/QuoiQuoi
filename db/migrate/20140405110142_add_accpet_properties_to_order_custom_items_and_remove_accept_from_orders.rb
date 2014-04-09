class AddAccpetPropertiesToOrderCustomItemsAndRemoveAcceptFromOrders < ActiveRecord::Migration
  def change
    add_column :order_custom_items, :accept, :boolean
    remove_column :orders, :accept
  end
end
