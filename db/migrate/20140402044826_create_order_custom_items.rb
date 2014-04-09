class CreateOrderCustomItems < ActiveRecord::Migration
  def change
    create_table :order_custom_items do |t|
      t.references :order, index: true
      t.references :product, index: true
      t.string :design
      t.string :style
      t.references :material, index: true
      t.string :description
      t.string :response
      t.integer :workday

      t.timestamps
    end
  end
end
