class CreateSlideTranslates < ActiveRecord::Migration
  def change
    create_table :slide_translates do |t|
      t.references :locale, index: true
      t.references :slide, index: true
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
