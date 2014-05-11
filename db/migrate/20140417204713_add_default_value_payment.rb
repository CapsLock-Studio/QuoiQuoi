class AddDefaultValuePayment < ActiveRecord::Migration
  def change
    change_column :payments, :completed, :boolean, default: false
    change_column :payments, :canceled, :boolean, default: false
    change_column :payments, :amount, :integer, default: 0
  end
end
