class RemoveReferenceAndAddEmailToUserGiftCard < ActiveRecord::Migration
  def change
    remove_reference :user_gift_serials, :user
    add_column :user_gift_serials, :email, :string
  end
end
