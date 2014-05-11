class AddTranslateTablesAndChangeCurrentTableStructure < ActiveRecord::Migration
  def change
    remove_column :products, :name
  end
end
