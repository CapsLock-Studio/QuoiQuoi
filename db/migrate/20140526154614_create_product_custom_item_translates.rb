class CreateProductCustomItemTranslates < ActiveRecord::Migration
  def change
    create_table :product_custom_item_translates do |t|
      t.references :product_custom_item, index: true
      t.references :locale, index: true
      t.string :name

      t.timestamps
    end
  end
end
