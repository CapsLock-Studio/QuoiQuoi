class CreateTopTranslates < ActiveRecord::Migration
  def change
    create_table :top_translates do |t|
      t.references :top, index: true
      t.string :link

      t.timestamps
    end
  end
end
