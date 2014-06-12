class CreateUserGifts < ActiveRecord::Migration
  def change
    create_table :user_gifts do |t|
      t.references :user, show: true
      t.references :gift, show: true
      t.string :token
      t.integer :used_user_id, show: true
      t.datetime :used_time

      t.timestamps
    end
  end
end
