class CreateGiftTranslates < ActiveRecord::Migration
  def change
    create_table :gift_translates do |t|
      t.references :gift, index: true
      t.references :locale, index: true
      t.string :name

      t.timestamps
    end
  end
end
