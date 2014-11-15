class AddHookOnMaterialType < ActiveRecord::Migration
  def change
    add_column :material_types, :all, :boolean, default: true
  end
end
