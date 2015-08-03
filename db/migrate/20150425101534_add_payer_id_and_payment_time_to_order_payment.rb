class AddPayerIdAndPaymentTimeToOrderPayment < ActiveRecord::Migration
  def change
    add_column :order_payments, :payer_id, :string
    add_column :order_payments, :payment_time, :datetime
  end
end
