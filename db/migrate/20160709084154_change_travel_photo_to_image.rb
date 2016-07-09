class ChangeTravelPhotoToImage < ActiveRecord::Migration
  def change
    remove_attachment :travel_photos, :photo
    add_attachment :travel_photos, :image
  end
end
