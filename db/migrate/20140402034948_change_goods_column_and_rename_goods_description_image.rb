class ChangeGoodsColumnAndRenameGoodsDescriptionImage < ActiveRecord::Migration
  def change
    rename_table :good_custom_description_images, :good_description_images
    rename_column :goods, :custom_description, :description
    add_column :goods, :design, :string
    add_column :goods, :style, :string
    add_reference :goods, :material
  end
end
