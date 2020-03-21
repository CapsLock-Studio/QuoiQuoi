class CreateProductTags < ActiveRecord::Migration[5.0]
  def change
    create_table :product_tags do |t|
      t.string :code
      t.references :product, foreign_key: true
      t.integer :sort

      t.timestamps
    end
  end
end
