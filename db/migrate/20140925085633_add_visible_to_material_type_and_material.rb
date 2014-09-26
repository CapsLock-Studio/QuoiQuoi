class AddVisibleToMaterialTypeAndMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :visible, :boolean, default: true
    add_column :material_types, :visible, :boolean, default: true
  end
end
