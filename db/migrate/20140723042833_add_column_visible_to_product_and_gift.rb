class AddColumnVisibleToProductAndGift < ActiveRecord::Migration
  def change
    add_column :products, :visible, :boolean, default: true
    add_column :gifts, :visible, :boolean, default: true
    add_column :courses, :visible, :boolean, default: true
  end
end
