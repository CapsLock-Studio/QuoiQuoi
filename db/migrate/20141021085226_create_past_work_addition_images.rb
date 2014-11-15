class CreatePastWorkAdditionImages < ActiveRecord::Migration
  def change
    create_table :past_work_addition_images do |t|
      t.attachment :image
      t.references :past_work, index: true

      t.timestamps
    end
  end
end
