class AddGiftReferenceToPayment < ActiveRecord::Migration
  def change
    add_reference :payments, :gift
  end
end
