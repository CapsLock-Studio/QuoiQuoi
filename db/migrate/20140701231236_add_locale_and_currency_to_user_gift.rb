class AddLocaleAndCurrencyToUserGift < ActiveRecord::Migration
  def change
    add_column :user_gifts, :currency, :string
    add_column :user_gifts, :locale_id, :integer
  end
end
