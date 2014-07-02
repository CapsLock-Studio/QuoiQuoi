class AddCurrencyToOrderCustomItem < ActiveRecord::Migration
  def change
    add_column :order_custom_items, :currency, :string
    add_column :order_custom_items, :locale_id, :integer
  end
end