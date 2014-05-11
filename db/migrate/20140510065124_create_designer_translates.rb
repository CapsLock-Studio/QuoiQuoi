class CreateDesignerTranslates < ActiveRecord::Migration
  def change
    create_table :designer_translates do |t|
      t.references :designer, index: true
      t.string :name
      t.string :introduction

      t.timestamps
    end
  end
end
