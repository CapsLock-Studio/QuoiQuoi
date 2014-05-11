class RenameAddColumnToOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :paid, :amount
    rename_column :orders, :paid_time, :pay_time
    add_column :orders, :payment_type, :integer
  end
end
