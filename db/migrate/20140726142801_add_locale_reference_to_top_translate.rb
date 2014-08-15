class AddLocaleReferenceToTopTranslate < ActiveRecord::Migration
  def change
    add_reference :top_translates, :locale, index: true
  end
end
