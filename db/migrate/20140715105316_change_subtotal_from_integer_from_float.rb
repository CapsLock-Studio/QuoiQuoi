class ChangeSubtotalFromIntegerFromFloat < ActiveRecord::Migration
  def change
    change_column :orders, :subtotal, :float
  end
end
