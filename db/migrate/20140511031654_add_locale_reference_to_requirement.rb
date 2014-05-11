class AddLocaleReferenceToRequirement < ActiveRecord::Migration
  def change
    add_reference :requirement_translates, :locale, index: true
  end
end
