class CreateProductTagTranslates < ActiveRecord::Migration[5.0]
  def change
    create_table :product_tag_translates do |t|
      t.belongs_to :product_tag, foreign_key: true
      t.belongs_to :locale, foreign_key: true

      t.string :name

      t.timestamps
    end
  end
end
