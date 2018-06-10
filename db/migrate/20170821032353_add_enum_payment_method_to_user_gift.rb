class AddEnumPaymentMethodToUserGift < ActiveRecord::Migration[5.0]
  def change
    add_column :user_gifts, :payment_method, :integer, default: 0
  end
end
