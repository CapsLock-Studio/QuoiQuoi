class CreateProductTypeTranslates < ActiveRecord::Migration
  def change
    create_table :product_type_translates do |t|
      t.string :name
      t.references :product_type
      t.references :locale

      t.timestamps
    end
  end
end
