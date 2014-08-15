class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.references :product, index: true
      t.string :content
      t.references :locale, index: true

      t.timestamps
    end
  end
end
