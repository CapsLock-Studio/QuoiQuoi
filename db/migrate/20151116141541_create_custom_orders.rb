class CreateCustomOrders < ActiveRecord::Migration
  def change
    create_table :custom_orders do |t|
      t.string :style
      t.string :type
      t.string :materials
      t.string :phone
      t.string :email
      t.string :line

      t.timestamps null: false
    end
  end
end
