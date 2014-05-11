class CreateOrderCustomItemMaterials < ActiveRecord::Migration
  def change
    create_table :order_custom_item_materials do |t|
      t.references :order_custom_item, index: true
      t.references :material, index: true

      t.timestamps
    end
  end
end
