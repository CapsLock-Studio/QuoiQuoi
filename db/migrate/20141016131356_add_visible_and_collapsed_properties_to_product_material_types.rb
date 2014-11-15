class AddVisibleAndCollapsedPropertiesToProductMaterialTypes < ActiveRecord::Migration
  def change
    add_column :product_material_types, :visible, :boolean, default: true
    add_column :product_material_types, :collapsed, :boolean, default: false
  end
end
