class CreateRentInfoImages < ActiveRecord::Migration
  def change
    create_table :rent_info_images do |t|
      t.attachment :image

      t.timestamps
    end
  end
end
