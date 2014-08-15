class CreateTops < ActiveRecord::Migration
  def change
    create_table :tops do |t|
      t.string :link
      t.attachment :image

      t.timestamps
    end
  end
end
