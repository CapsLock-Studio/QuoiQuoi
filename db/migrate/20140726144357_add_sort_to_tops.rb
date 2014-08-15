class AddSortToTops < ActiveRecord::Migration
  def change
    add_column :tops, :sort, :integer
  end
end
