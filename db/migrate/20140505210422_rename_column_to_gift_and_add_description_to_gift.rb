class RenameColumnToGiftAndAddDescriptionToGift < ActiveRecord::Migration
  def change
    add_column :gift_translates, :description, :string
  end
end
