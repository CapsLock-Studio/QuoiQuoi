class AddCollapsedPropertyToMaterialType < ActiveRecord::Migration
  def change
    add_column :material_types, :collapsed, :boolean, default: false
  end
end
