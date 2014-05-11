class CreateUserGifts < ActiveRecord::Migration
  def change
    create_table :user_gifts do |t|
      t.references :user, index: true
      t.references :gift, index: true
      t.string :token
      t.integer :used_user_id, index: true
      t.datetime :used_time

      t.timestamps
    end
  end
end
