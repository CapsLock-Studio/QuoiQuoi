class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.references :locale, index: true
      t.text :content

      t.timestamps
    end
  end
end
