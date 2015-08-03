class AddReferenceToOrderAndOrderPayment < ActiveRecord::Migration
  def change
    add_reference :order_payments, :order, index: true
  end
end
