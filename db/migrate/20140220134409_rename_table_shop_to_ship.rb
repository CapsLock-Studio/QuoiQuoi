class RenameTableShopToShip < ActiveRecord::Migration
  def change
    rename_table :shops, :ships
  end
end
