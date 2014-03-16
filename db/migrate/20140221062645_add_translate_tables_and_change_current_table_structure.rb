class AddTranslateTablesAndChangeCurrentTableStructure < ActiveRecord::Migration
  def change
    remove_column :products, :name
    remove_column :product_custom_types, :name
    remove_column :product_custom_items, :name
  end
end
