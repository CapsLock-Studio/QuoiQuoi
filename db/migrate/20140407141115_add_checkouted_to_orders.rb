class AddCheckoutedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :checkout, :boolean
  end
end
