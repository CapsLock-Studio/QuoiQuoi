class AddUserGiftRefenceToGift < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_gift_payments, :user_gift, index: true
  end
end
