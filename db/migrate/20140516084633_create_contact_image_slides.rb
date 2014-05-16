class CreateContactImageSlides < ActiveRecord::Migration
  def change
    create_table :contact_image_slides do |t|
      t.integer :sort
      t.attachment :image

      t.timestamps
    end
  end
end
