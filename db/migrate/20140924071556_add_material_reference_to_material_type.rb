class AddMaterialReferenceToMaterialType < ActiveRecord::Migration
  def change
    add_reference :materials, :material_types, index: true
  end
end
