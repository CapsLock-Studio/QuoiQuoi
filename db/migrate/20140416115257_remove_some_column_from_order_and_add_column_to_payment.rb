class RemoveSomeColumnFromOrderAndAddColumnToPayment < ActiveRecord::Migration
  def change
    remove_column :orders, :verified
    remove_column :orders, :pay_time
    remove_column :orders, :payment_type
    remove_column :orders, :amount

    add_column :registrations, :closed, :boolean
    add_column :registrations, :closed_time, :datetime

    add_column :payments, :pay_time, :datetime
    add_column :payments, :wait, :boolean
  end
end
