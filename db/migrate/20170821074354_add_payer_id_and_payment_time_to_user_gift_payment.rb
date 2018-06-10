class AddPayerIdAndPaymentTimeToUserGiftPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :user_gift_payments, :payer_id, :string
    add_column :user_gift_payments, :payment_time, :datetime
  end
end
