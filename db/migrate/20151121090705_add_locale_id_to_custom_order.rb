class AddLocaleIdToCustomOrder < ActiveRecord::Migration
  def change
    add_reference :custom_orders, :locale
  end
end
