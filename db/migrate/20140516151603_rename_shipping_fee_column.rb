class RenameShippingFeeColumn < ActiveRecord::Migration
  def change
    rename_column :shipping_fees, :country, :area
  end
end
