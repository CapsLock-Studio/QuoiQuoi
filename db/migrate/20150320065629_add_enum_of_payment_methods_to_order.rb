class AddEnumOfPaymentMethodsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :payment_method, :integer, default: 0
  end
end
