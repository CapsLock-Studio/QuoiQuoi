class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.integer :order_id
      t.integer :product_id
      t.string :custom_description
      t.string :note
      t.integer :workday
      t.integer :quantity

      t.timestamps
    end
  end
end
