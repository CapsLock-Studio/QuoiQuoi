class CreateProductTranslates < ActiveRecord::Migration
  def change
    create_table :product_translates do |t|
      t.integer :locale_id
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
