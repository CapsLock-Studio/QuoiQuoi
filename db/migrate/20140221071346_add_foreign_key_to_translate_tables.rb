class AddForeignKeyToTranslateTables < ActiveRecord::Migration
  def change
    add_column :product_translates, :product_id, :integer
    add_column :product_custom_type_translates, :product_custom_type_id, :integer
    add_column :product_custom_item_translates, :product_custom_item_id, :integer
  end
end
