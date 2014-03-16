class CreateGoodCustomDescriptionImages < ActiveRecord::Migration
  def change
    create_table :good_custom_description_images do |t|
      t.integer :good_id
      t.string :image

      t.timestamps
    end
  end
end
