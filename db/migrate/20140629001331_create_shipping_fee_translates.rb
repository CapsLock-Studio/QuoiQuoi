class CreateShippingFeeTranslates < ActiveRecord::Migration
  def change
    create_table :shipping_fee_translates do |t|
      t.references :locale, index: true
      t.references :shipping_fee, index: true
      t.float :fee
      t.float :fee_condition

      t.timestamps
    end
  end
end
