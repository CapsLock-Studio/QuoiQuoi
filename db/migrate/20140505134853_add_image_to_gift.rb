class AddImageToGift < ActiveRecord::Migration
  def change
    add_attachment :gifts, :image
  end
end
