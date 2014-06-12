class CreateOrderCustomItems < ActiveRecord::Migration
  def change
    create_table :order_custom_items do |t|
      t.references :order, show: true
      t.references :product, show: true
      t.string :design
      t.string :style
      t.references :material, show: true
      t.string :description
      t.string :response
      t.integer :workday

      t.timestamps
    end
  end
end
