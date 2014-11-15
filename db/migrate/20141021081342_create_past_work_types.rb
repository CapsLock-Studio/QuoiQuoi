class CreatePastWorkTypes < ActiveRecord::Migration
  def change
    create_table :past_work_types do |t|
      t.attachment :thumbnail
      t.attachment :image
      t.integer :sort
      t.boolean :visible, default: true

      t.timestamps
    end
  end
end
