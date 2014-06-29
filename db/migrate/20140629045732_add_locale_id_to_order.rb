class AddLocaleIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :locale_id, :integer
  end
end
