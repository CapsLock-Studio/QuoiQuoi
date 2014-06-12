class CreateGiftTranslates < ActiveRecord::Migration
  def change
    create_table :gift_translates do |t|
      t.references :gift, show: true
      t.references :locale, show: true
      t.string :name

      t.timestamps
    end
  end
end
