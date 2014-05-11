class AddCheckoutToRegistration < ActiveRecord::Migration
  def change
    remove_column :registrations, :accept
    add_column :registrations, :checkout, :boolean
    add_column :registrations, :checkout_time, :datetime
  end
end