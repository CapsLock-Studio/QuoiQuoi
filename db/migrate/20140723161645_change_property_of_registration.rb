class ChangePropertyOfRegistration < ActiveRecord::Migration
  def change
    change_column :registrations, :subtotal, :float
  end
end
