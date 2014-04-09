class AddSortToBroadcast < ActiveRecord::Migration
  def change
    add_column :broadcasts, :sort, :integer
  end
end
