class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.attachment :image

      t.timestamps
    end
  end
end
