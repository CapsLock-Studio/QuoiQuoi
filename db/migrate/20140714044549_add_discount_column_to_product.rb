class AddDiscountColumnToProduct < ActiveRecord::Migration
  def change
    add_column :products, :discount, :float, default: 0
  end
end
