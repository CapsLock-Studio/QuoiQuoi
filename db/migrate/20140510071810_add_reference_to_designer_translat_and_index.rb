class AddReferenceToDesignerTranslatAndIndex < ActiveRecord::Migration
  def change
    add_reference :designer_translates, :locale, index: true
  end
end
