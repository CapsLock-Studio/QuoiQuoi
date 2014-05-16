class CreateContactYoutubeSlides < ActiveRecord::Migration
  def change
    create_table :contact_youtube_slides do |t|
      t.integer :sort
      t.string :youtube

      t.timestamps
    end
  end
end
