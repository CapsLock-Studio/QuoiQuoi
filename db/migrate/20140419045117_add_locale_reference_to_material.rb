class AddLocaleReferenceToMaterial < ActiveRecord::Migration
  def change
    add_reference :materials, :locale
  end
end
