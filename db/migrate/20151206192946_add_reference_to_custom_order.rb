class AddReferenceToCustomOrder < ActiveRecord::Migration
  def change
    add_reference :messages, :custom_order
  end
end
