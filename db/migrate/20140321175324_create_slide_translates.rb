class CreateSlideTranslates < ActiveRecord::Migration
  def change
    create_table :slide_translates do |t|
      t.references :locale, show: true
      t.references :slide, show: true
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
