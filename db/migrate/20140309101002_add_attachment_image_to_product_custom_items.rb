class AddAttachmentImageToProductCustomItems < ActiveRecord::Migration
  def self.up
    change_table :product_custom_items do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :product_custom_items, :image
  end
end
