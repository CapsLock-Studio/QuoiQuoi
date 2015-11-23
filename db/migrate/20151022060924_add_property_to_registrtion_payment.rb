class AddPropertyToRegistrtionPayment < ActiveRecord::Migration
  def change
    add_column :registration_payments, :refunded, :boolean, default: false
    add_column :registration_payments, :refunded_time, :datetime
  end
end
