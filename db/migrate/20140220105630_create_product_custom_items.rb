class CreateProductCustomItems < ActiveRecord::Migration
  def change
    create_table :product_custom_items do |t|
      t.integer :product_id
      t.integer :product_custom_type_id
      t.string :name
      t.string :image
      t.integer :price
      t.integer :workday

      t.timestamps
    end
  end
end
