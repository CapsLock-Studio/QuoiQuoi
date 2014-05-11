class CreateDesigners < ActiveRecord::Migration
  def change
    create_table :designers do |t|
      t.attachment :photo

      t.timestamps
    end
  end
end
