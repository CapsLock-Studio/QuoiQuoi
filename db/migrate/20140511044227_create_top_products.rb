class CreateTopProducts < ActiveRecord::Migration
  def change
    create_table :top_products do |t|
      t.references :product, index: true
      t.integer :sort

      t.timestamps
    end
  end
end
