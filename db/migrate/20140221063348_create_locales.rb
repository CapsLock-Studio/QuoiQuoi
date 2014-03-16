class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.string :lang

      t.timestamps
    end
  end
end
