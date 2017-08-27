class AddMessageToUserGift < ActiveRecord::Migration[5.0]
  def change
    add_column :user_gift_remittance_reports, :message, :text
  end
end
