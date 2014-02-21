class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.integer :order_id
      t.integer :paid
      t.boolean :delivered

      t.timestamps
    end
  end
end
