class ChangeUserGiftColumns < ActiveRecord::Migration
  def change
    remove_column :user_gifts, :used_time
    remove_column :user_gifts, :used_user_id
    remove_column :user_gifts, :token
    add_column :user_gifts, :quantity, :integer

    add_reference :user_gift_serials, :user, index: true
    add_column :user_gift_serials, :used_time, :datetime
  end
end
