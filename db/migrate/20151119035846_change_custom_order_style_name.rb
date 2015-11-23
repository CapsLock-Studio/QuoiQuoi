class ChangeCustomOrderStyleName < ActiveRecord::Migration
  def change
    rename_column :custom_orders, :type, :order_type
  end
end
