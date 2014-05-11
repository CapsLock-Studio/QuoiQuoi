class RemoveCheckoutFromRegistration < ActiveRecord::Migration
  def change
    remove_column :registrations, :checkout
    remove_column :registrations, :checkout_time
  end
end
