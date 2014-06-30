class AddLocaleIdAndCurrencyToUserGift < ActiveRecord::Migration
  def change
    add_column :user_gifts, :lcoale_id, :integer
    add_column :user_gifts, :currency, :string
  end
end
