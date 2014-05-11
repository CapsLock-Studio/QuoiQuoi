class CreateArticleTypeTranslates < ActiveRecord::Migration
  def change
    create_table :article_type_translates do |t|
      t.references :article_type, index: true
      t.references :locale, index: true
      t.string :name

      t.timestamps
    end
  end
end
