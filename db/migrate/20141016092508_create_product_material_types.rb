class CreateProductMaterialTypes < ActiveRecord::Migration
  def change
    create_table :product_material_types do |t|
      t.references :product, index: true
      t.references :material_type, index: true

      t.timestamps
    end
  end
end
