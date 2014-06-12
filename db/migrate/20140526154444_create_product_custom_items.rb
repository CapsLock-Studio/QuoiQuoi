class CreateProductCustomItems < ActiveRecord::Migration
  def change
    create_table :product_custom_items do |t|
      t.references :product, show: true
      t.attachment :image

      t.timestamps
    end
  end
end
