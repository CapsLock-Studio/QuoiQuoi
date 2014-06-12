class CreateRentIntroTranslates < ActiveRecord::Migration
  def change
    create_table :rent_intro_translates do |t|
      t.references :rent_intro, show: true
      t.references :locale, show: true
      t.string :description

      t.timestamps
    end
  end
end
