class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.integer :order_id
      t.integer :paid
      t.boolean :delivered

      t.timestamps
    end
  end
end
