class AddReferenceToUserGiftCard < ActiveRecord::Migration
  def change
    add_reference :user_gifts, :order, index: true
    add_reference :user_gifts, :registration, index: true
  end
end
