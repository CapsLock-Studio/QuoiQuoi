class AddDissmissMessageToCustomOrder < ActiveRecord::Migration
  def change
    add_column :custom_orders, :dismiss_message, :text
  end
end
