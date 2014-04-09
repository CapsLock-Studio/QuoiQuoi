class CreateSlidePositions < ActiveRecord::Migration
  def change
    create_table :slide_positions do |t|
      t.attachment :image
      t.string :position

      t.timestamps
    end
  end
end
