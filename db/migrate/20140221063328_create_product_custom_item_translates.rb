class CreateProductCustomItemTranslates < ActiveRecord::Migration
  def change
    create_table :product_custom_item_translates do |t|
      t.integer :locale_id
      t.string :name

      t.timestamps
    end
  end
end
