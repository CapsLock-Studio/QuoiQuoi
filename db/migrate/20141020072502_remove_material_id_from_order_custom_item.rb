class RemoveMaterialIdFromOrderCustomItem < ActiveRecord::Migration
  def change
    remove_reference :order_custom_items, :material
  end
end
