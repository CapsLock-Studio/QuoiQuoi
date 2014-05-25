class CreateOrderInformations < ActiveRecord::Migration
  def change
    create_table :order_informations do |t|
      t.string :type
      t.text :reference
      t.text :note

      t.timestamps
    end
  end
end
