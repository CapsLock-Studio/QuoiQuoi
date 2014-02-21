class CreateGoodCustomItems < ActiveRecord::Migration
  def change
    create_table :good_custom_items do |t|
      t.integer :good_id
      t.integer :product_custom_item_id

      t.timestamps
    end
  end
end
