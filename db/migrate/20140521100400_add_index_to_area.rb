class AddIndexToArea < ActiveRecord::Migration
  def change
    remove_reference :areas, :locale
    add_reference :areas, :locale, show: true
    remove_reference :article_types, :locale
    add_reference :article_types, :locale, show: true
  end
end
