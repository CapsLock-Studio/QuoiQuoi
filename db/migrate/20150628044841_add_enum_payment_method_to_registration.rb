class AddEnumPaymentMethodToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :payment_method, :integer, default: 0
  end
end
