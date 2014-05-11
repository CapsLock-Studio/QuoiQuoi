class AddImageToOrderCustomItem < ActiveRecord::Migration
  def change
    add_attachment :order_custom_items, :image
  end
end
