class CreateRentInfoTranslates < ActiveRecord::Migration
  def change
    create_table :rent_info_translates do |t|
      t.references :rent_info, show: true
      t.references :locale, show: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
