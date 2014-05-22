class CreateTravelPhotos < ActiveRecord::Migration
  def change
    create_table :travel_photos do |t|
      t.references :travel_information, index: true
      t.attachment :photo

      t.timestamps
    end
  end
end
