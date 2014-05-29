class RenameTableContactToIntroduction < ActiveRecord::Migration
  def change
    rename_table :contact_image_slides, :introduce_image_slides
    rename_table :contact_youtube_slides, :introduce_youtubes
  end
end
