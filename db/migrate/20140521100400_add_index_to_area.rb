class AddIndexToArea < ActiveRecord::Migration
  def change
    remove_reference :areas, :locale
    add_reference :areas, :locale, index: true
    remove_reference :article_types, :locale
    add_reference :article_types, :locale, index: true
  end
end
