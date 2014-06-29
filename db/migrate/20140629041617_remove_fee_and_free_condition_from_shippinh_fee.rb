class RemoveFeeAndFreeConditionFromShippinhFee < ActiveRecord::Migration
  def change
    remove_column :shipping_fees, :fee
    remove_column :shipping_fees, :free_condition
  end
end
