class AddAttachmentImageToGoodCustomDescriptionImages < ActiveRecord::Migration
  def self.up
    change_table :good_custom_description_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :good_custom_description_images, :image
  end
end
