class AddImageToProductTag < ActiveRecord::Migration[5.0]
  def change
    add_attachment :product_tags, :thumbnail
    add_attachment :product_tags, :image
  end
end
