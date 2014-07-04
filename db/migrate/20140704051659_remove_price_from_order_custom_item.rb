class RemovePriceFromOrderCustomItem < ActiveRecord::Migration
  def change
    remove_column :order_custom_items, :price, :locale_id, :currency
  end
end
