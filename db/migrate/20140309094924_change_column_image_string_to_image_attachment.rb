class ChangeColumnImageStringToImageAttachment < ActiveRecord::Migration
  def change
    remove_column :products, :image
    remove_column :product_custom_items, :image
  end
end
