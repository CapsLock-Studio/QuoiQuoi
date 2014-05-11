class AddInfoToOrderCustomItem < ActiveRecord::Migration
  def change
    add_column :order_custom_items, :name, :string
    add_column :order_custom_items, :phone, :string
    add_column :order_custom_items, :line, :string
  end
end
