class AddCancelHandleToUserGiftPaymeny < ActiveRecord::Migration[5.0]
  def change
    add_column :user_gift_payments, :cancel, :boolean, default: false
    add_column :user_gift_payments, :cancel_reason, :text
    add_column :user_gift_payments, :cancel_time, :datetime
  end
end
