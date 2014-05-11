class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.integer :quota

      t.timestamps
    end
  end
end
