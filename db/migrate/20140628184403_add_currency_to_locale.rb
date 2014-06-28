class AddCurrencyToLocale < ActiveRecord::Migration
  def change
    add_column :locales, :currency, :string
  end
end
