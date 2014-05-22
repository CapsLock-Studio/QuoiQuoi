class RemoveArticleTransalteAndAddLocaleReferenceToArticleType < ActiveRecord::Migration
  def change
    add_reference :article_types, :locale
    add_column :article_types, :name, :string
  end
end
