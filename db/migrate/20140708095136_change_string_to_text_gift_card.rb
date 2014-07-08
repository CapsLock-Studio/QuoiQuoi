class ChangeStringToTextGiftCard < ActiveRecord::Migration
  def change
    change_column :gift_translates, :description, :text
  end
end
