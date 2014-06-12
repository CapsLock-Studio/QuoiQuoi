class AddLocaleReferenceToRequirement < ActiveRecord::Migration
  def change
    add_reference :requirement_translates, :locale, show: true
  end
end
