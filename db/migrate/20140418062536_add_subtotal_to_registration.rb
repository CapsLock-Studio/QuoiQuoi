class AddSubtotalToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :subtotal, :integer
  end
end
