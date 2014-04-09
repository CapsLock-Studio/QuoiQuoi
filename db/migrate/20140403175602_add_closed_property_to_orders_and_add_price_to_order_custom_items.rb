class AddClosedPropertyToOrdersAndAddPriceToOrderCustomItems < ActiveRecord::Migration
  def change
    add_column :orders, :closed, :boolean
    add_column :order_custom_items, :price, :integer
  end
end
