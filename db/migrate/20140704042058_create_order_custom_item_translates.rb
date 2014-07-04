class CreateOrderCustomItemTranslates < ActiveRecord::Migration
  def change
    create_table :order_custom_item_translates do |t|
      t.references :order_custom_item, index: true
      t.references :locale, index: true
      t.float :price

      t.timestamps
    end
  end
end
