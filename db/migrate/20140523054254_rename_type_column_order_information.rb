class RenameTypeColumnOrderInformation < ActiveRecord::Migration
  def change
    rename_column :order_informations, :type, :bag_type
  end
end
