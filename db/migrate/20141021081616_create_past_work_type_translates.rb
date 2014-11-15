class CreatePastWorkTypeTranslates < ActiveRecord::Migration
  def change
    create_table :past_work_type_translates do |t|
      t.string :name
      t.string :description
      t.references :past_work_type, index: true

      t.timestamps
    end
  end
end
