class RemoveLinkFromTops < ActiveRecord::Migration
  def change
    remove_column :tops, :link
  end
end
