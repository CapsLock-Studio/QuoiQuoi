class AddShippingFeeToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :shipping_fee, index: true
  end
end
