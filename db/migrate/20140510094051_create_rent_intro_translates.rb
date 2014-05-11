class CreateRentIntroTranslates < ActiveRecord::Migration
  def change
    create_table :rent_intro_translates do |t|
      t.references :rent_intro, index: true
      t.references :locale, index: true
      t.string :description

      t.timestamps
    end
  end
end
