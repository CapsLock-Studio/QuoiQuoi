class RemoveReferenceFromMaterialAndAddReferenceToMaterialTranslates < ActiveRecord::Migration
  def change
    remove_reference :materials, :locale
    add_reference :material_translates, :locale
  end
end
