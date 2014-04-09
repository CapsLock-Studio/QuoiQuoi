class ChangeColumnLengthIntegerToDouble < ActiveRecord::Migration
  def change
    change_column :courses, :length, :float
  end
end
