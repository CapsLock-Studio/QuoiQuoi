class AddUserReferenceToCustomOrder < ActiveRecord::Migration
  def change
    add_reference :custom_orders, :user, index: true
  end
end
