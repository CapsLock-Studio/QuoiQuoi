class CreateOrderCustomItemMaterials < ActiveRecord::Migration
  def change
    create_table :order_custom_item_materials do |t|
      t.references :order_custom_item, show: true
      t.references :material, show: true

      t.timestamps
    end
  end
end
