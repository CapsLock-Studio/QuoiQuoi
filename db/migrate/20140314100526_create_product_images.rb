class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.references :product, show: true
      t.attachment :image

      t.timestamps
    end
  end
end
