class RemovePhoneColumn < ActiveRecord::Migration
  def change
    remove_column :contact_translates, :mobile
  end
end
