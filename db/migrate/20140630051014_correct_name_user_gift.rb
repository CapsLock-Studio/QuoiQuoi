class CorrectNameUserGift < ActiveRecord::Migration
  def change
    rename_column :user_gifts, :lcoale_id, :locale_id
  end
end
