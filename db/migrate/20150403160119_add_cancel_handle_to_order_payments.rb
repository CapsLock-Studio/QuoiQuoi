class AddCancelHandleToOrderPayments < ActiveRecord::Migration
  def change
    add_column :order_payments, :cancel, :boolean, default: false
    add_column :order_payments, :cancel_reason, :text
    add_column :order_payments, :cancel_time, :datetime
  end
end