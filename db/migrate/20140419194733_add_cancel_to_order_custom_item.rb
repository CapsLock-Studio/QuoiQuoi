class AddCancelToOrderCustomItem < ActiveRecord::Migration
  def change
    add_column :order_custom_items, :canceled, :boolean, default: false
    add_column :order_custom_items, :canceled_time, :datetime
  end
end
