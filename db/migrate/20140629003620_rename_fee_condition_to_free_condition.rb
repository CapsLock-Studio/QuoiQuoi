class RenameFeeConditionToFreeCondition < ActiveRecord::Migration
  def change
    rename_column :shipping_fee_translates, :fee_condition, :free_condition
  end
end
