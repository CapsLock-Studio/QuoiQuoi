class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.integer :sort
      t.string :link
      t.attachment :image

      t.timestamps
    end
  end
end
