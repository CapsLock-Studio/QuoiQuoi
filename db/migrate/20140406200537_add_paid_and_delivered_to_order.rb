class AddPaidAndDeliveredToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :verified, :boolean
    add_column :orders, :paid, :integer
    add_column :orders, :paid_time, :datetime
    add_column :orders, :delivered, :boolean
  end
end
