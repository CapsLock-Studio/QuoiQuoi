class CreatePastWorkTranslates < ActiveRecord::Migration
  def change
    create_table :past_work_translates do |t|
      t.references :locale, index: true
      t.references :past_work, index: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
