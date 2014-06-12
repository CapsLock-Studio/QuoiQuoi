class AddReferenceToDesignerTranslatAndIndex < ActiveRecord::Migration
  def change
    add_reference :designer_translates, :locale, show: true
  end
end
