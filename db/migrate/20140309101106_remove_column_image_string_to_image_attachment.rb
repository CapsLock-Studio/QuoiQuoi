class RemoveColumnImageStringToImageAttachment < ActiveRecord::Migration
  def change
    remove_column :good_custom_description_images, :image
  end
end
