class AddCanceledAndCanceledTimeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :canceled, :boolean, default: false
    add_column :orders, :canceled_time, :datetime
    change_column :order_custom_items, :canceled, :boolean, default: false
  end
end
