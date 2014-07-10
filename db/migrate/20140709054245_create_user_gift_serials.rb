class CreateUserGiftSerials < ActiveRecord::Migration
  def change
    create_table :user_gift_serials do |t|
      t.references :user_gift, index: true
      t.string :serial

      t.timestamps
    end
  end
end
