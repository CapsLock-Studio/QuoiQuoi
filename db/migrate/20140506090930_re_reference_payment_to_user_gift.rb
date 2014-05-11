class ReReferencePaymentToUserGift < ActiveRecord::Migration
  def change
    remove_reference :payments, :gift
    add_reference :payments, :user_gift
  end
end
