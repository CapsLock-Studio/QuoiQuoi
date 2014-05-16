class CreateShippingFees < ActiveRecord::Migration
  def change
    create_table :shipping_fees do |t|
      t.string :country
      t.integer :fee
      t.integer :free_condition

      t.timestamps
    end
  end
end
