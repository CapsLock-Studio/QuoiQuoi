class CreateProductCustomTypes < ActiveRecord::Migration
  def change
    create_table :product_custom_types do |t|
      t.string :name
      t.boolean :multi

      t.timestamps
    end
  end
end
