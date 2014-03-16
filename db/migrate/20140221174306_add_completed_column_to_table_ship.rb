class AddCompletedColumnToTableShip < ActiveRecord::Migration
  def change
    add_column :ships, :completed, :boolean
  end
end
