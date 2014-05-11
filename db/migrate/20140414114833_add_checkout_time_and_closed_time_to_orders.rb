class AddCheckoutTimeAndClosedTimeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :checkout_time, :datetime
    add_column :orders, :closed_time, :datetime
  end
end
