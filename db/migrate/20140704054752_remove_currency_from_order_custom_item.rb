class RemoveCurrencyFromOrderCustomItem < ActiveRecord::Migration
  def change
    remove_column :order_custom_items, :currency
  end
end
