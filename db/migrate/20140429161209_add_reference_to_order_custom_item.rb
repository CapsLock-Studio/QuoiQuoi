class AddReferenceToOrderCustomItem < ActiveRecord::Migration
  def change
    add_reference :order_custom_items, :user
  end
end
