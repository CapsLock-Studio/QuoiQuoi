class AddQuotaToGiftTranslate < ActiveRecord::Migration
  def change
    add_column :gift_translates, :quota, :float
    remove_column :gifts, :quota
  end
end
