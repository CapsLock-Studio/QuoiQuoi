class CreatePastWorks < ActiveRecord::Migration
  def change
    create_table :past_works do |t|
      t.date :completion_time
      t.attachment :image
      t.boolean :visible, default: true
      t.references :past_work_type, index: true

      t.timestamps
    end
  end
end
