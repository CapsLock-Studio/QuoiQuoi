class AddReferenceToUserSerial < ActiveRecord::Migration
  def change
    add_reference :user_gift_serials, :order, index: true
    add_reference :user_gift_serials, :registration, index: true
  end
end
