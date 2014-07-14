class AddPriceToOrderProduct < ActiveRecord::Migration
  def change
    add_column :order_products, :price, :float, default: 0
    add_column :order_products, :discount, :float, default: 0
  end
end
