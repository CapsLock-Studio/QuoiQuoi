class CreateMaterialTypeTranslates < ActiveRecord::Migration
  def change
    create_table :material_type_translates do |t|
      t.references :material_type, index: true
      t.references :locale, index: true
      t.string :name

      t.timestamps
    end
  end
end
