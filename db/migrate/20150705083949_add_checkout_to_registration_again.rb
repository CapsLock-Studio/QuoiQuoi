class AddCheckoutToRegistrationAgain < ActiveRecord::Migration
  def change
    add_column :registrations, :checkout, :boolean, default: false
    add_column :registrations, :checkout_time, :datetime
  end
end
