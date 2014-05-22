class AddLocaleReferenceToAreaAndAddNameColumn < ActiveRecord::Migration
  def change
    add_reference :areas, :locale
    add_column :areas, :name, :string
  end
end
