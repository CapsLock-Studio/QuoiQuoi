class CreateMaterialTranslates < ActiveRecord::Migration
  def change
    create_table :material_translates do |t|
      t.string :name
      t.references :material, show: true

      t.timestamps
    end
  end
end
