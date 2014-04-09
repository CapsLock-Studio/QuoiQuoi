class CreateMaterialTranslates < ActiveRecord::Migration
  def change
    create_table :material_translates do |t|
      t.string :name
      t.references :material, index: true

      t.timestamps
    end
  end
end
