class AddCheckoutToUserGift < ActiveRecord::Migration[5.0]
  def change
    add_column :user_gifts, :checkout, :boolean
    add_column :user_gifts, :checkout_time, :datetime
  end
end
