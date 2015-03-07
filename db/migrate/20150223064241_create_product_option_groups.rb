class CreateProductOptionGroups < ActiveRecord::Migration
  def change
    create_table :product_option_groups do |t|
      t.references :product, index: true
      t.references :locale, index: true
      t.string :name

      t.timestamps
    end
  end
end
