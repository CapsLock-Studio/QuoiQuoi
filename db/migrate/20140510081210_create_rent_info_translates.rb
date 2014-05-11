class CreateRentInfoTranslates < ActiveRecord::Migration
  def change
    create_table :rent_info_translates do |t|
      t.references :rent_info, index: true
      t.references :locale, index: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
