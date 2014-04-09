class CreateOrderCustomItemImages < ActiveRecord::Migration
  def change
    create_table :order_custom_item_images do |t|
      t.attachment :image
      t.references :order_custom_item, index: true

      t.timestamps
    end
  end
end
